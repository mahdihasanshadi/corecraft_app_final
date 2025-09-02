import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/logo_widget.dart';

class HelpSupportView extends StatefulWidget {
  const HelpSupportView({super.key});

  @override
  State<HelpSupportView> createState() => _HelpSupportViewState();
}

class _HelpSupportViewState extends State<HelpSupportView> {
  final List<Map<String, dynamic>> _faqCategories = [
    {
      'title': 'Order & Delivery',
      'icon': Icons.local_shipping,
      'color': Colors.blue,
      'faqs': [
        {
          'question': 'How long does delivery take in Bangladesh?',
          'answer': 'Standard delivery takes 3-5 business days within Dhaka and 5-7 days for other cities. Express delivery is available for 1-2 days in major cities.',
        },
        {
          'question': 'What are the delivery charges?',
          'answer': 'Delivery charges are ৳150 for Dhaka and ৳200 for other cities. Free delivery on orders above ৳2000.',
        },
        {
          'question': 'Can I track my order?',
          'answer': 'Yes! You can track your order through the "My Orders" section in your profile. We\'ll also send SMS updates.',
        },
      ],
    },
    {
      'title': 'Payment & Billing',
      'icon': Icons.payment,
      'color': Colors.green,
      'faqs': [
        {
          'question': 'What payment methods do you accept?',
          'answer': 'We currently accept Cash on Delivery (COD) for all orders. Online payment options will be available soon.',
        },
        {
          'question': 'Is there any hidden cost?',
          'answer': 'No hidden costs! The price you see is what you pay. Only delivery charge (৳150-200) and VAT (5%) are added.',
        },
        {
          'question': 'Can I get an invoice?',
          'answer': 'Yes, a detailed invoice is included with every order and can also be downloaded from your order history.',
        },
      ],
    },
    {
      'title': 'Returns & Refunds',
      'icon': Icons.assignment_return,
      'color': Colors.orange,
      'faqs': [
        {
          'question': 'What is your return policy?',
          'answer': 'We offer 7-day return policy for unused items in original packaging. Damaged or defective items can be returned within 30 days.',
        },
        {
          'question': 'How do I return an item?',
          'answer': 'Contact our customer service at 01812-345678 or email support@corecraft.bd. We\'ll arrange pickup from your address.',
        },
        {
          'question': 'When will I get my refund?',
          'answer': 'Refunds are processed within 3-5 business days after we receive the returned item.',
        },
      ],
    },
    {
      'title': 'Product Information',
      'icon': Icons.info,
      'color': Colors.purple,
      'faqs': [
        {
          'question': 'Are your products authentic?',
          'answer': 'Yes, all our products are 100% authentic. We source directly from authorized manufacturers and distributors.',
        },
        {
          'question': 'What sizes do you offer?',
          'answer': 'We offer sizes XS to XXL for most clothing items. Detailed size charts are available on each product page.',
        },
        {
          'question': 'Do you have plus sizes?',
          'answer': 'Yes, we offer extended sizes for many items. Look for the "Plus Size" filter in our categories.',
        },
      ],
    },
  ];

  final List<Map<String, dynamic>> _contactOptions = [
    {
      'title': 'Customer Service',
      'subtitle': 'Available 24/7',
      'icon': Icons.headset_mic,
      'color': Colors.blue,
      'action': 'Call Now',
      'value': '01812-345678',
    },
    {
      'title': 'WhatsApp Support',
      'subtitle': 'Quick responses',
      'icon': Icons.chat_bubble,
      'color': Colors.green,
      'action': 'Chat Now',
      'value': '+880 1812-345678',
    },
    {
      'title': 'Email Support',
      'subtitle': 'Detailed queries',
      'icon': Icons.email,
      'color': Colors.red,
      'action': 'Send Email',
      'value': 'support@corecraft.bd',
    },
    {
      'title': 'Live Chat',
      'subtitle': 'Real-time help',
      'icon': Icons.chat,
      'color': Colors.purple,
      'action': 'Start Chat',
      'value': 'Available on website',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black87),
          ),
          onPressed: () => Get.back(),
        ),
        title: const LogoWidget(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildContactSection(),
            _buildFAQSection(),
            _buildSupportSection(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF2C3E50),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.help_outline,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Help & Support',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'আমরা আপনাকে সাহায্য করতে এখানে আছি',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We are here to help you',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Us',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemCount: _contactOptions.length,
            itemBuilder: (context, index) {
              final option = _contactOptions[index];
              return _buildContactCard(option);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(Map<String, dynamic> option) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: option['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                option['icon'],
                color: option['color'],
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              option['title'],
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              option['subtitle'],
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _handleContactAction(option),
              style: ElevatedButton.styleFrom(
                backgroundColor: option['color'],
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                option['action'],
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frequently Asked Questions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 16),
          ..._faqCategories.map((category) => _buildFAQCategory(category)).toList(),
        ],
      ),
    );
  }

  Widget _buildFAQCategory(Map<String, dynamic> category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: category['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            category['icon'],
            color: category['color'],
            size: 20,
          ),
        ),
        title: Text(
          category['title'],
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          ...category['faqs'].map((faq) => _buildFAQItem(faq)).toList(),
        ],
      ),
    );
  }

  Widget _buildFAQItem(Map<String, dynamic> faq) {
    return ExpansionTile(
      title: Text(
        faq['question'],
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            faq['answer'],
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.support_agent,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          Text(
            'Need More Help?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Our customer support team is available 24/7 to assist you with any questions or concerns.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _openLiveChat(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Live Chat',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _callSupport(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF2C3E50),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Call Now',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleContactAction(Map<String, dynamic> option) {
    switch (option['title']) {
      case 'Customer Service':
        _callSupport();
        break;
      case 'WhatsApp Support':
        _openWhatsApp();
        break;
      case 'Email Support':
        _sendEmail();
        break;
      case 'Live Chat':
        _openLiveChat();
        break;
    }
  }

  void _callSupport() {
    Get.snackbar(
      'Calling Support',
      'Calling 01812-345678...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF2C3E50),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void _openWhatsApp() {
    Get.snackbar(
      'WhatsApp Support',
      'Opening WhatsApp chat...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void _sendEmail() {
    Get.snackbar(
      'Email Support',
      'Opening email app...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void _openLiveChat() {
    Get.snackbar(
      'Live Chat',
      'Opening live chat...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.purple,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}
