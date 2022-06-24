import 'package:gas_provider/models/product_model.dart';

List<ProductModel> allProducts = [
  ProductModel(
      name: 'Super Leaded Petrol',
      category: 'Petrol',
      description:
          'Non veniam occaecat laboris dolore do adipisicing consectetur tempor veniam velit fugiat amet.',
      price: '151'),
  ProductModel(
      name: 'Natural Gas',
      category: 'Gas',
      description:
          'Non veniam occaecat laboris dolore do adipisicing consectetur tempor veniam velit fugiat amet.',
      price: '87'),
  ProductModel(
      name: 'Diesel V2',
      category: 'Diesel',
      description:
          'Non veniam occaecat laboris dolore do adipisicing consectetur tempor veniam velit fugiat amet.',
      price: '120'),
];

List<Map<String, dynamic>> paymentMethods = [
  {
    'icon': 'https://www.un.org/sites/un2.un.org/files/mpesa.png',
    'name': 'M-Pesa',
    'details': '0796 **** 87'
  },
  // {
  //   'icon': 'https://www.un.org/sites/un2.un.org/files/visa.png',
  //   'name': 'Visa',
  //   'details': '8719 **** **** 1892'
  // },
  {
    'icon':
        'https://logos-world.net/wp-content/uploads/2020/09/Mastercard-Logo.png',
    'name': 'Credit Card',
    'details': '8719 **** **** 1892'
  },
  {
    'name': 'PayPal',
    'icon':
        'https://seeklogo.com/images/P/paypal-logo-481A2E654B-seeklogo.com.png',
    'details': 'Pay via paypal wallet'
  },
  {
    'icon':
        'https://toppng.com/uploads/preview/cash-in-hand-icon-11549486230pl37r7u3fu.png',
    'name': 'Cash',
    'details': 'Pay on Arrival',
  }
];

List<String> deliveryStatus = [
  'Pending approval',
  'Your order is being prepared',
  'Driver is on the way to pick your order',
  'Driver is on the way to you',
  'Your order is ready for pickup',
];
