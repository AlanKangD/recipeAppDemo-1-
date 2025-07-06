import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../utils/constants.dart';

class TimerWidget extends StatefulWidget {
  final int initialMinutes;
  final String title;

  const TimerWidget({
    super.key,
    this.initialMinutes = 10,
    required this.title,
  });

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late int _remainingSeconds;
  bool _isRunning = false;
  late FlutterLocalNotificationsPlugin _notifications;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.initialMinutes * 60;
    _initializeNotifications();
  }

  void _initializeNotifications() {
    _notifications = FlutterLocalNotificationsPlugin();
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    _notifications.initialize(initSettings);
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _isRunning) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            _isRunning = false;
            _showNotification();
          }
        });
        if (_isRunning) {
          _startTimer();
        }
      }
    });
  }

  void _pauseTimer() {
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _remainingSeconds = widget.initialMinutes * 60;
    });
  }

  void _showNotification() {
    const androidDetails = AndroidNotificationDetails(
      'timer_channel',
      'Timer Notifications',
      channelDescription: 'Notifications for cooking timer',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    _notifications.show(
      0,
      '타이머 완료!',
      '${widget.title} 타이머가 완료되었습니다.',
      details,
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 제목
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          // 타이머 표시
          Text(
            _formatTime(_remainingSeconds),
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          // 버튼들
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 시작/일시정지 버튼
              ElevatedButton.icon(
                onPressed: _remainingSeconds > 0
                    ? (_isRunning ? _pauseTimer : _startTimer)
                    : null,
                icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                label: Text(_isRunning ? '일시정지' : '시작'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isRunning ? Colors.orange : AppColors.primary,
                ),
              ),
              // 리셋 버튼
              ElevatedButton.icon(
                onPressed: _resetTimer,
                icon: const Icon(Icons.refresh),
                label: const Text('리셋'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
