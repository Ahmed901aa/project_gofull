import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/features/notifications/domain/entities/notification_entity.dart';
import 'package:project_gofull/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/widgets/directional_icon.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NotificationBloc>()..add(const LoadNotificationsEvent()),
      child: Scaffold(
          backgroundColor: context.colors.background,
          body: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: BlocBuilder<NotificationBloc, NotificationState>(
                  builder: (context, state) {
                    if (state is NotificationLoading) {
                      return Center(child: CircularProgressIndicator(color: context.colors.primary));
                    }
                    if (state is NotificationError) {
                      return Center(
                        child: Text(state.message,
                            style: getRegularStyle(color: context.colors.iconSecondary, fontSize: FontSize.s14)),
                      );
                    }
                    if (state is NotificationsLoaded) {
                      return _buildList(context, state.notifications);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      );
  }

  Widget _buildList(BuildContext context, List<NotificationEntity> notifications) {
    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_off_outlined, size: 56.sp, color: context.colors.border),
            SizedBox(height: Insets.s12),
            Text(S.of(context).noNotifications,
                style: getSemiBoldStyle(color: context.colors.textSecondary, fontSize: FontSize.s16)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: context.colors.primary,
      onRefresh: () async {
        context.read<NotificationBloc>().add(const LoadNotificationsEvent());
      },
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: EdgeInsets.all(Insets.s16),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => SizedBox(height: Insets.s8),
        itemBuilder: (context, index) => _NotificationCard(notification: notifications[index]),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => Container(
        color: context.colors.surface,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Padding(
              padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(backArrowIcon(context), size: 24.sp, color: context.colors.textPrimary),
                  ),
                  Expanded(
                    child: Text(
                      S.of(context).notifications,
                      style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 24.sp),
                ],
              ),
            ),
            Divider(height: 1, color: context.colors.borderSubtle),
          ],
        ),
      );
}

class _NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  const _NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    final date = notification.createdAt?.substring(0, 16).replaceAll('T', ' ') ?? '';

    return Container(
      padding: EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: context.colors.primarySurface,
              borderRadius: BorderRadius.circular(AppRadius.s12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.s12),
              child: Image.asset(
                'assets/images/logo_1.png',
                width: 40.w,
                height: 40.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: Insets.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.title,
                    style: getSemiBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s14)),
                SizedBox(height: 4.h),
                Text(notification.body,
                    style: getRegularStyle(color: context.colors.textSecondary, fontSize: FontSize.s12),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis),
                SizedBox(height: 6.h),
                Text(date,
                    style: getRegularStyle(color: context.colors.iconSecondary, fontSize: FontSize.s12),
                    textDirection: TextDirection.ltr),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
