const express = require("express");
const router = express.Router();

const { addReview, getProviderReviews } = require("../controllers/reviewController");
const { protect } = require("../middleware/authMiddleware");

// Customer adds review
router.post("/", protect, addReview);

// Public: provider reviews list (Flutter profile page)
router.get("/provider/:providerId", getProviderReviews);

module.exports = router;
