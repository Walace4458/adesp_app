import '../models/report_model.dart';

class ReportService {
  static final Map<String, List<ReportModel>> _reports = {};

  static List<ReportModel> getReports(String cellId) {
    return _reports[cellId] ?? [];
  }

  static ReportModel? getLastReport(String cellId) {
    final list = _reports[cellId];
    if (list == null || list.isEmpty) return null;
    return list.last;
  }

  static void addReport(ReportModel report) {
    if (_reports[report.cellId] == null) {
      _reports[report.cellId] = [];
    }

    _reports[report.cellId]!.add(report);
  }

  static List<ReportModel> reports = [];

    static void saveReport(ReportModel report) {
      reports.add(report);
  }
}