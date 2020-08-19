Product = require('../models/ProductsModels');

exports.index = (req, res) => {
    Product.get((err, product) => {
        if (err) {
            res.json({
                status: 'err',
                code: 500,
                message: err
            });
        }

        res.json(product)
    })
}

//create function for new product
exports.new = function(req, res) {
    let product = new Product()
    product.name = req.body.name
    product.price = req.body.price
    product.stock = req.body.stock
    product.nit = req.body.nit
    product.categoria = req.body.categoria
    product.descripcion = req.body.descripcion
    product.razon = req.body.razon
    product.mostrar = req.body.mostrar
    product.save(function(err) {
        if (err) {
            res.json({
                status: 'err',
                code: 500,
                message: err
            })
        }
        res.json({
            status: 'success',
            code: 200,
            message: 'Register save',
            data: product
        })
    })
}


exports.by = function(req, res) {
    Product.find({nit: req.params.nit}, function(err, product) {
        if (err) {
            res.json({
                status: 'err',
                code: 500,
                message: err
            })
        }
        res.json(product)
    })
}

//create fucntion view products
exports.view = function(req, res) {
    Product.findById(req.params.id, function(err, product) {
        if (err) {
            res.json({
                status: 'err',
                code: 500,
                message: err
            })
        }
        res.json({
            status: 'success',
            code: 200,
            message: 'Registros encontrado',
            data: product
        })
    })
}

exports.update = function(req, res) {
    Product.findById(req.params.id, function(err, product) {
        if (err)
            res.json({
                status: 'err',
                code: 500,
                message: err
            })
        product.name = req.body.name
        product.price = req.body.price
        product.stock = req.body.stock
        product.save(function(err) {
            if (err)
                res.json({
                    status: 'err',
                    code: 500,
                    message: err
                })
            res.json({
                status: 'success',
                code: 200,
                message: 'Registro actualizado',
                data: product
            })
        })
    })
}


exports.delete = function(req, res) {
    Product.remove({
        _id: req.params.id
    }, function(err) {
        if (err)
            res.json({
                status: 'err',
                code: 500,
                message: err
            })
        res.json({
            status: 'success',
            code: 200,
            message: 'Registros eliminado'
        })
    })
}