const Review = require("../models/Review");
const Booking = require("../models/Booking");
const Provider = require("../models/Provider");

// ✅ Add review (only customer, only for their booking, 1 review per booking)
exports.addReview = async (req, res) => {
  try {
    if (req.user.role !== "customer") {
      return res.status(403).json({ message: "Only customers can add reviews" });
    }

    const { bookingId, rating, comment } = req.body || {};

    if (!bookingId || !rating) {
      return res.status(400).json({ message: "bookingId and rating are required" });
    }

    if (rating < 1 || rating > 5) {
      return res.status(400).json({ message: "rating must be between 1 and 5" });
    }

    const booking = await Booking.findById(bookingId);
    if (!booking) {
      return res.status(404).json({ message: "Booking not found" });
    }

    // Booking must belong to the logged-in customer
    if (booking.customer.toString() !== req.user._id.toString()) {
      return res.status(403).json({ message: "Not authorized to review this booking" });
    }

    // ✅ Optional: allow review only after confirmed/completed
    // If you want strict:
    // if (!["confirmed", "completed"].includes(booking.status)) {
    //   return res.status(400).json({ message: "You can review only after confirmation/completion" });
    // }

    // One review per booking
    const existing = await Review.findOne({ booking: bookingId });
    if (existing) {
      return res.status(400).json({ message: "Review already submitted for this booking" });
    }

    // booking.provider is Provider profile _id ✅
    const review = await Review.create({
      booking: bookingId,
      customer: req.user._id,
      provider: booking.provider,
      rating,
      comment: comment || "",
    });

    // ✅ Recalculate provider rating + totalReviews
    const allReviews = await Review.find({ provider: booking.provider });

    const avg =
      allReviews.reduce((sum, r) => sum + (r.rating || 0), 0) / allReviews.length;

    await Provider.findByIdAndUpdate(booking.provider, {
      rating: Number(avg.toFixed(1)),
      totalReviews: allReviews.length,
    });

    res.status(201).json({
      message: "Review added successfully",
      review,
      providerStats: { rating: Number(avg.toFixed(1)), totalReviews: allReviews.length },
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// ✅ Get all reviews for a provider (public - useful for Flutter)
exports.getProviderReviews = async (req, res) => {
  try {
    const { providerId } = req.params;

    const reviews = await Review.find({ provider: providerId })
      .populate("customer", "name")
      .sort({ createdAt: -1 });

    res.json(reviews);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
