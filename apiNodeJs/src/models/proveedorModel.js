const { Schema, model } = require('mongoose');
const bcrypt = require('bcryptjs');

const proveedorSchema = new Schema({
    nit: String,
    razon: String,
    phone: String,
    email: String,
    password: String   
    
});

proveedorSchema.methods.encryptPassword = async(password) => {
    const salt = await bcrypt.genSalt(10);
    return bcrypt.hash(password, salt);
};

proveedorSchema.methods.validatePassword = function(password) {
    return bcrypt.compare(password, this.password);
};

module.exports = model('Proveedor', proveedorSchema)