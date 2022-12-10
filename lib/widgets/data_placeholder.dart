import 'package:app_center_agent/utils/enums.dart';
import 'package:flutter/material.dart';

const _kDefaultPlaceholderDataMap = {
  NetworkState.idle: NetworkStatePlaceholderData(
      title: 'Oops!', subTitle: 'Can not load this data.'),
  NetworkState.loading: NetworkStatePlaceholderData(
      title: 'Hold on!', subTitle: 'Please wait while we load this data.'),
  NetworkState.error: NetworkStatePlaceholderData(
      title: 'Oops!', subTitle: 'Error loading this data.'),
  NetworkState.success: NetworkStatePlaceholderData(
    title: 'No Data',
    subTitle: 'No data found.',
  ),
};

class DataPlaceholder extends StatelessWidget {
  const DataPlaceholder({
    super.key,
    required this.state,
    this.placeholderDataMap,
  });

  factory DataPlaceholder.singleState(
      {required NetworkStatePlaceholderData child,
      required NetworkState state}) {
    return DataPlaceholder(
      state: state,
      placeholderDataMap: {
        state: child,
      },
    );
  }

  final NetworkState state;
  final Map<NetworkState, NetworkStatePlaceholderData>? placeholderDataMap;

  @override
  Widget build(BuildContext context) {
    final data = _kDefaultPlaceholderDataMap[state]!.copyWith(
      title: placeholderDataMap?[state]?.title,
      subTitle: placeholderDataMap?[state]?.subTitle,
      actionTitle: placeholderDataMap?[state]?.actionTitle,
      onAction: placeholderDataMap?[state]?.onAction,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (data.title != null)
            Text(
              data.title!,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 16),
          if (data.subTitle != null)
            Text(
              data.subTitle!,
              style: const TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 18),
          if (state.isLoading)
            const CircularProgressIndicator()
          else if (data.actionTitle != null)
            ElevatedButton(
              onPressed: data.onAction,
              child: Text(
                data.actionTitle!,
                style: const TextStyle(fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }
}

class NetworkStatePlaceholderData {
  final String? title;
  final String? subTitle;
  final String? actionTitle;
  final VoidCallback? onAction;

  const NetworkStatePlaceholderData({
    this.title,
    this.subTitle,
    this.actionTitle,
    this.onAction,
  }) : assert(
            actionTitle == null || onAction != null,
            'onAction is required '
            'If actionTitle is provided.');

  NetworkStatePlaceholderData copyWith({
    String? title,
    String? subTitle,
    String? actionTitle,
    VoidCallback? onAction,
  }) =>
      NetworkStatePlaceholderData(
        title: title ?? this.title,
        subTitle: subTitle ?? this.subTitle,
        actionTitle: actionTitle ?? this.actionTitle,
        onAction: onAction ?? this.onAction,
      );
}
