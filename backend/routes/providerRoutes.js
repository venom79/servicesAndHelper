const express = require("express");
const router = express.Router();
const { createProvider, getProviders } = require("../controllers/providerController");
const { protect } = require("../middleware/authMiddleware");

router.post("/", protect, createProvider);
router.get("/", getProviders);

module.exports = router;
