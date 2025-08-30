import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../pos/data/models/product_model.dart';


class ProductDialog extends StatefulWidget {
  final ProductModel? product;
  final void Function(ProductModel) onSubmit;

  const ProductDialog({
    super.key,
    this.product,
    required this.onSubmit,
  });

  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _barcodeController;
  late TextEditingController _companyController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _quantityController;
  late TextEditingController _imageController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.product?.name ?? "");
    _barcodeController =
        TextEditingController(text: widget.product?.barcode ?? "");
    _companyController =
        TextEditingController(text: widget.product?.company ?? "");
    _priceController =
        TextEditingController(text: widget.product?.price.toString() ?? "");
    _stockController =
        TextEditingController(text: widget.product?.stock.toString() ?? "");
    _quantityController =
        TextEditingController(text: widget.product?.quantity.toString() ?? "");
    _imageController =
        TextEditingController(text: widget.product?.imageUrl ?? "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    _companyController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _quantityController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        widget.product == null ? "Add Product" : "Edit Product",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: AppColors.textPrimary,
        ),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(controller: _nameController, label: "Name"),
              _buildTextField(controller: _barcodeController, label: "Barcode"),
              _buildTextField(controller: _companyController, label: "Company"),
              _buildTextField(
                  controller: _priceController,
                  label: "Price",
                  keyboardType: TextInputType.number),
              _buildTextField(
                  controller: _stockController,
                  label: "Stock",
                  keyboardType: TextInputType.number),
              _buildTextField(
                  controller: _quantityController,
                  label: "Quantity",
                  keyboardType: TextInputType.number),
              _buildTextField(controller: _imageController, label: "Image Path / URL"),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textGray,
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: AppColors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              final newProduct = ProductModel(
                barcode: _barcodeController.text,
                name: _nameController.text,
                price: double.tryParse(_priceController.text) ?? 0.0,
                quantity: int.tryParse(_quantityController.text) ?? 0,
                company: _companyController.text,
                stock: int.tryParse(_stockController.text) ?? 0,
                imageUrl: _imageController.text,
              );
              widget.onSubmit(newProduct);
              Navigator.pop(context);
            }
          },
          child: Text(widget.product == null ? "Add" : "Update"),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator ??
            (v) => (v == null || v.isEmpty) ? "Enter $label" : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.textGray, fontSize: 14),
          filled: true,
          fillColor: AppColors.cardBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.borderGray),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.borderGray),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.primaryBlue, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }
}
