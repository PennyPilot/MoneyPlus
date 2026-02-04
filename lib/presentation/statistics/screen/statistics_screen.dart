import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/statistics_cubit.dart';
import '../cubit/statistics_state.dart';
import '../widgets/CategoryBreakdown.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: BlocBuilder<StatisticsCubit, StatisticsState>(
        builder: (context, state) {
          if (state.status == StatisticsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == StatisticsStatus.failure) {
            return Center(child: Text(state.error?.message ?? 'An error occurred'));
          } else if (state.status == StatisticsStatus.success && state.categoriesBreakdown != null) {
            return CategoryBreakdownWidget(categoriesBreakdown: state.categoriesBreakdown!);
          } else {
            return const Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}
