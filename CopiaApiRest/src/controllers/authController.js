const { Router } = require('express');
const router = Router();

const User = require('../models/UserModel');
const Proveedor = require('../models/proveedorModel');
const verifyToken = require('./verifyToken')

const jwt = require('jsonwebtoken');
const config = require('../config');

const productController = require('../controllers/productController')



router.post('/searchUser', async(req, res) => {
    try {
        const user = await User.findOne({ email: req.body.email })
        if (!user) {
            try {
                const proveedor = await Proveedor.findOne({ email: req.body.email })
                if (!proveedor) {
                    res.status(200).json({ existe: false});
                }
                res.status(200).json({ existe: true});
            } catch (e) {
                console.log(e)
                res.status(500).send('There was a problem signin');
            }
        }
        res.status(200).json({ existe: true });
    } catch (e) {
        console.log(e)
        res.status(500).send('There was a problem signin');
    }
});


router.post('/signin', async(req, res) => {
    try {
        const user = await User.findOne({ email: req.body.email })
        if (!user) {
            try {
                const proveedor = await Proveedor.findOne({ email: req.body.email })
                if (!proveedor) {
                    return res.status(404).send("The email doesn't exists")
                }
                const validPasswordProv = await proveedor.validatePassword(req.body.password, proveedor.password);
                if (!validPasswordProv) {
                    return res.status(401).send({ auth: false, token: null });
                }
                const token = jwt.sign({ id: proveedor._id }, config.secret, {
                    expiresIn: '24h'
                });
                res.status(200).json({ auth: true, token, rol: "proveedor", nit:  proveedor.nit, razon:  proveedor.razon});
            } catch (e) {
                console.log(e)
                res.status(500).send('There was a problem signin');
            }
        }
        const validPassword = await user.validatePassword(req.body.password, user.password);
        if (!validPassword) {
            return res.status(401).send({ auth: false, token: null });
        }
        const token = jwt.sign({ id: user._id }, config.secret, {
            expiresIn: '24h'
        });
        res.status(200).json({ auth: true, token, rol: "cliente", cliente: user.username });
    } catch (e) {
        console.log(e)
        res.status(500).send('There was a problem signin');
    }
});


//Client//
router.post('/signupClient', async(req, res) => {
    try {
        // Receiving Data
        const { username, email, password, address, phone } = req.body;
        // Creating a new User
        const user = new User({
            username,
            email,
            password,
            address,
            phone
        });
        user.password = await user.encryptPassword(password);
        await user.save();
        // Create a Token
        const token = jwt.sign({ id: user.id }, config.secret, {
            expiresIn: 60 * 60 * 24 // expires in 24 hours
        });

        res.json({ auth: true, token });

    } catch (e) {
        console.log(e)
        res.status(500).send('There was a problem registering your user');
    }
});


//Proveedor//

router.post('/signupProveedor', async(req, res) => {
    try {
        // Receiving Data
        const { nit, razon, phone, email, password } = req.body;
        // Creating a new Proveedor
        const proveedor = new Proveedor({
            nit,
            razon,
            phone,
            email,
            password 
        });
        proveedor.password = await proveedor.encryptPassword(password);
        await proveedor.save();
        // Create a Token
        const token = jwt.sign({ id: proveedor.id }, config.secret, {
            expiresIn: 60 * 60 * 24 // expires in 24 hours
        });

        res.json({ auth: true, token, nit: nit, razon: razon});

    } catch (e) {
        console.log(e)
        res.status(500).send('There was a problem registering your proveedor');
    }
});

//Products//

router.route('/products')
    .get(productController.index)
    .post(productController.new)

router.route('/productBy/:nit')
    .get(productController.by)

router.route('/product/:id')
    .post(productController.view)
    .put(productController.update)
    .delete(productController.delete)


router.get('/dashboard', (req, res) => {
    res.json('dashboard');
})

router.get('/logout', function(req, res) {
    res.status(200).send({ auth: false, token: null });
});

module.exports = router;