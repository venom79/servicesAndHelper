const Booking = require("../models/Booking");
const Provider = require("../models/Provider");

// ✅ Create booking (only customer)
// Expects providerId = Provider collection _id
exports.createBooking = async (req, res) => {
  try {
    if (req.user.role !== "customer") {
      return res
        .status(403)
        .json({ message: "Only customers can book services" });
    }

    const { providerId, date, timeSlot } = req.body || {};

    if (!providerId || !date || !timeSlot) {
      return res.status(400).json({
        message: "providerId, date, and timeSlot are required",
      });
    }

    // Ensure provider profile exists
    const providerProfile = await Provider.findById(providerId);
    if (!providerProfile) {
      return res.status(404).json({ message: "Provider not found" });
    }

    // ✅ Prevent slot conflicts for same provider/date/timeSlot
    // If any booking is pending/confirmed for that slot, block new booking.
    const slotTaken = await Booking.findOne({
      provider: providerId,
      date,
      timeSlot,
      status: { $in: ["pending", "confirmed"] },
    });

    if (slotTaken) {
      return res.status(400).json({
        message: "This time slot is already booked. Please choose another slot.",
      });
    }

    // ✅ Prevent duplicate booking by same customer for same slot (extra safe)
    const existing = await Booking.findOne({
      customer: req.user._id,
      provider: providerId,
      date,
      timeSlot,
    });

    if (existing) {
      return res
        .status(400)
        .json({ message: "You already booked this slot" });
    }

    const booking = await Booking.create({
      customer: req.user._id,
      provider: providerId,
      date,
      timeSlot,
      status: "pending",
    });

    res.status(201).json(booking);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// ✅ Get bookings (customer sees own, provider sees own)
exports.getBookings = async (req, res) => {
  try {
    const { status, date, from, to, page = 1, limit = 50, providerId } = req.query;

    // Build common filters (only add if provided)
    const commonFilters = {};
    if (status) commonFilters.status = status;

    // If you always store ISO format "YYYY-MM-DD", string comparisons work.
    if (date) {
      commonFilters.date = date;
    } else if (from || to) {
      commonFilters.date = {};
      if (from) commonFilters.date.$gte = from;
      if (to) commonFilters.date.$lte = to;
    }

    const skip = (Number(page) - 1) * Number(limit);

    // CUSTOMER: only their bookings
    if (req.user.role === "customer") {
      const findQuery = { customer: req.user._id, ...commonFilters };

      const bookings = await Booking.find(findQuery)
        .populate({
          path: "provider",
          populate: { path: "user", select: "name email" },
        })
        .sort({ createdAt: -1 })
        .skip(skip)
        .limit(Number(limit));

      return res.json(bookings);
    }

    // PROVIDER: only bookings of their provider profile
    if (req.user.role === "provider") {
      const providerProfile = await Provider.findOne({ user: req.user._id });

      if (!providerProfile) {
        return res.status(404).json({ message: "Provider profile not found" });
      }

      const findQuery = { provider: providerProfile._id, ...commonFilters };

      const bookings = await Booking.find(findQuery)
        .populate("customer", "name email")
        .populate({
          path: "provider",
          populate: { path: "user", select: "name email" },
        })
        .sort({ createdAt: -1 })
        .skip(skip)
        .limit(Number(limit));

      return res.json(bookings);
    }

    // ADMIN: see all (+ optional providerId filter)
    if (req.user.role === "admin") {
      const findQuery = { ...commonFilters };
      if (providerId) findQuery.provider = providerId; // Provider profile _id

      const bookings = await Booking.find(findQuery)
        .populate("customer", "name email")
        .populate({
          path: "provider",
          populate: { path: "user", select: "name email" },
        })
        .sort({ createdAt: -1 })
        .skip(skip)
        .limit(Number(limit));

      return res.json(bookings);
    }

    return res.status(403).json({ message: "Invalid role" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};


// ✅ Update booking status (only the booking's provider)
exports.updateBookingStatus = async (req, res) => {
  try {
    if (req.user.role !== "provider") {
      return res
        .status(403)
        .json({ message: "Only providers can update bookings" });
    }

    const { status } = req.body || {};
    const allowed = ["pending", "confirmed", "rejected", "completed"];

    if (!status || !allowed.includes(status)) {
      return res.status(400).json({
        message: `status must be one of: ${allowed.join(", ")}`,
      });
    }

    const booking = await Booking.findById(req.params.id);
    if (!booking) {
      return res.status(404).json({ message: "Booking not found" });
    }

    const providerProfile = await Provider.findOne({ user: req.user._id });
    if (!providerProfile) {
      return res.status(404).json({ message: "Provider profile not found" });
    }

    // Ensure provider owns this booking
    if (booking.provider.toString() !== providerProfile._id.toString()) {
      return res
        .status(403)
        .json({ message: "Not authorized to update this booking" });
    }

    booking.status = status;
    await booking.save();

    res.json(booking);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
