import 'package:flutter_test/flutter_test.dart';
import 'package:servis/features/service_records/domain/service_record.dart';
import 'package:servis/features/service_records/domain/service_record_item.dart';

void main() {
  group('Service Record Calculation Tests', () {
    test('Calculates items total and overall total with additional cost', () {
      final items = [
        const ServiceRecordItem(
          id: '1',
          serviceRecordId: 'rec_1',
          itemName: 'Ganti Oli Mesin',
          itemCost: 65000,
        ),
        const ServiceRecordItem(
          id: '2',
          serviceRecordId: 'rec_1',
          itemName: 'Filter Udara',
          itemCost: 45000,
        ),
        const ServiceRecordItem(
          id: '3',
          serviceRecordId: 'rec_1',
          itemName: 'Busi Standar',
          itemCost: 25000,
        ),
      ];

      final record = ServiceRecord(
        id: 'rec_1',
        motorcycleId: 'm1',
        serviceDate: DateTime(2026, 5, 10),
        odometerKm: 15000,
        workshopName: 'AHASS Pusat',
        additionalCost: 15000, // Jasa pasang
        items: items,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(record.itemsTotalCost, 135000);
      expect(record.totalCost, 150000); // 135000 + 15000
    });

    test('Zero additional cost defaults properly', () {
      final items = [
        const ServiceRecordItem(
          id: '1',
          serviceRecordId: 'rec_2',
          itemName: 'Cek Rem',
          itemCost: 0,
        ),
      ];

      final record = ServiceRecord(
        id: 'rec_2',
        motorcycleId: 'm1',
        serviceDate: DateTime(2026, 5, 10),
        odometerKm: 15000,
        additionalCost: 0,
        items: items,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(record.itemsTotalCost, 0);
      expect(record.totalCost, 0);
    });

    test('Item summary generates correct descriptions', () {
      final recEmpty = ServiceRecord(
        id: 'r0',
        motorcycleId: 'm1',
        serviceDate: DateTime.now(),
        odometerKm: 1000,
        items: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      expect(recEmpty.itemsSummary, 'Tidak ada pekerjaan');

      final rec1 = ServiceRecord(
        id: 'r1',
        motorcycleId: 'm1',
        serviceDate: DateTime.now(),
        odometerKm: 1000,
        items: const [
          ServiceRecordItem(
              id: '1',
              serviceRecordId: 'r1',
              itemName: 'Oli Mesin',
              itemCost: 50000),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      expect(rec1.itemsSummary, 'Oli Mesin');

      final rec2 = ServiceRecord(
        id: 'r2',
        motorcycleId: 'm1',
        serviceDate: DateTime.now(),
        odometerKm: 1000,
        items: const [
          ServiceRecordItem(
              id: '1',
              serviceRecordId: 'r2',
              itemName: 'Oli Mesin',
              itemCost: 50000),
          ServiceRecordItem(
              id: '2',
              serviceRecordId: 'r2',
              itemName: 'Busi',
              itemCost: 20000),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      expect(rec2.itemsSummary, 'Oli Mesin, Busi');

      final rec4 = ServiceRecord(
        id: 'r4',
        motorcycleId: 'm1',
        serviceDate: DateTime.now(),
        odometerKm: 1000,
        items: const [
          ServiceRecordItem(
              id: '1',
              serviceRecordId: 'r4',
              itemName: 'Oli Mesin',
              itemCost: 50000),
          ServiceRecordItem(
              id: '2',
              serviceRecordId: 'r4',
              itemName: 'Busi',
              itemCost: 20000),
          ServiceRecordItem(
              id: '3',
              serviceRecordId: 'r4',
              itemName: 'Filter Udara',
              itemCost: 40000),
          ServiceRecordItem(
              id: '4',
              serviceRecordId: 'r4',
              itemName: 'Kampas Rem',
              itemCost: 60000),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      expect(rec4.itemsSummary, 'Oli Mesin, Busi (+2 lainnya)');
    });
  });
}
