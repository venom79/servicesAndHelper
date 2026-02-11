const dotenv = require("dotenv");
const mongoose = require("mongoose");
const bcrypt = require("bcryptjs");
const User = require("./models/User");

dotenv.config();

(async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI);

    const email = process.env.ADMIN_EMAIL;
    const password = process.env.ADMIN_PASSWORD;

    const existing = await User.findOne({ email });
    if (existing) {
      console.log("Admin already exists");
      process.exit(0);
    }

    const hashed = await bcrypt.hash(password, 10);

    await User.create({
      name: "Admin",
      email,
      password: hashed,
      role: "admin",
    });

    console.log("Admin created:", email);
    process.exit(0);
  } catch (e) {
    console.error(e);
    process.exit(1);
  }
})();
