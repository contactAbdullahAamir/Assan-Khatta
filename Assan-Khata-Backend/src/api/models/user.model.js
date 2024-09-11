const mongoose = require("mongoose");
const Schema = mongoose.Schema;
const bcrypt = require("bcryptjs");

const userSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, default: "User" },
    email: { type: String, required: true, unique: true },
    password: {
      type: String,
      required: function () {
        return !this.googleId && !this.magicLinkToken;
      },
    },
    isVerified: { type: Boolean, default: false },
    verificationCode: { type: String, default: null },
    magicLinkToken: { type: String, default: null },
    googleId: { type: String, default: null },
    profilePic: {
      type: String,
      default: null,
    },
    contacts: [{ type: Schema.Types.ObjectId, ref: "User" }],
    requests: [{ type: Schema.Types.ObjectId, ref: "User" }],
  },
  { timestamps: true }
);

// Create partial index
userSchema.index({ googleId: 1 }, { unique: true, partialFilterExpression: { googleId: { $exists: true, $ne: null } } });

userSchema.statics.findOrCreate = async function (profile, cb) {
  try {
    let user = await this.findOne({ googleId: profile.id });
    if (!user) {
      user = await this.create({
        googleId: profile.id,
        email: profile.emails[0].value,
        name: profile.displayName,
        isVerified: true,
      });
    }
    return cb(null, user);
  } catch (err) {
    return cb(err);
  }
};

module.exports = mongoose.model("User", userSchema);
