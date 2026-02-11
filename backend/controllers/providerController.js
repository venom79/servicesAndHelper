const Provider = require("../models/Provider");

// Create provider profile (only provider role)
exports.createProvider = async (req, res) => {
  try {
    if (req.user.role !== "provider") {
      return res.status(403).json({ message: "Only providers can create profile" });
    }

    if (!req.body) {
        return res.status(400).json({ message: "Request body missing" });
    }

    const { category, description, city, pricePerHour } = req.body;


    const provider = await Provider.create({
      user: req.user._id,
      category,
      description,
      city,
      pricePerHour,
    });

    res.status(201).json(provider);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get providers (filter by city + category)
exports.getProviders = async (req, res) => {
  try {
    const { city, category, minRating, maxPrice, sort, q } = req.query;

    const filter = {};

    if (city) filter.city = new RegExp(`^${city}$`, "i"); // case-insensitive exact match
    if (category) filter.category = category;

    if (minRating) filter.rating = { $gte: Number(minRating) };
    if (maxPrice) filter.pricePerHour = { $lte: Number(maxPrice) };

    // optional: text-like search on description (and you can expand later)
    if (q) filter.description = { $regex: q, $options: "i" };

    let query = Provider.find(filter).populate("user", "name email");

    // sorting
    if (sort === "rating") query = query.sort({ rating: -1 });
    else if (sort === "price_low") query = query.sort({ pricePerHour: 1 });
    else if (sort === "price_high") query = query.sort({ pricePerHour: -1 });
    else query = query.sort({ createdAt: -1 });

    const providers = await query;
    res.json(providers);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
