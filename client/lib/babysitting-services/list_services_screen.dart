import 'package:client/babysitting-services/components/request_card.dart';
import 'package:client/babysitting-services/model.dart';
import 'package:client/babysitting-services/service.dart';
import 'package:client/common/app_bar.dart';
import 'package:flutter/material.dart';

class BabysittingRequestsPage extends StatefulWidget {
  const BabysittingRequestsPage({super.key});

  @override
  _BabysittingRequestsPageState createState() =>
      _BabysittingRequestsPageState();
}

class _BabysittingRequestsPageState extends State<BabysittingRequestsPage> {
  List<BabySittingServiceData> services = [];

  @override
  void initState() {
    super.initState();
    getServices();
  }

  Future<void> getServices() async {
    try {
      final data = await BabySittingService.getBabySittingServiceList();

      setState(() {
        services = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load services')),
      );
    }
  }

  Future<void> _acceptService(String serviceId) async {
    try {
      await BabySittingService.acceptService(serviceId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao aceitar o Serviço')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 215, 229),
      appBar: CustomAppBar(
        title: 'Serviços Disponíveis',
        onBackButtonPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              final request = services[index];
              return RequestCard(
                enrollments: request.enrollments,
                tutorName: request.tutorName,
                childrenCount: request.childrenCount,
                startDate: request.startDate,
                endDate: request.endDate,
                address: request.address,
                value: request.value.toInt(),
                id: request.id,
                tutorId: request.tutorId,
                onAccept: () => _acceptService(request.id),
              );
            },
          )),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} às ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
