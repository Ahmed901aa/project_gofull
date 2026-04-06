import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/features/fuel/presentation/widgets/rating_notes_section.dart';
import 'package:project_gofull/features/fuel/presentation/widgets/rating_stars_section.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';

class RatingScreen extends StatefulWidget {
  final RatingArgs? args;
  const RatingScreen({super.key, this.args});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _rating = 0;
  final _notesController = TextEditingController();
  static const int _maxNoteLength = 80;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s32),
              child: Column(
                children: [
                  RatingStarsSection(rating: _rating, onRatingChanged: (v) => setState(() => _rating = v)),
                  if (_rating > 0) ...[
                    SizedBox(height: Insets.s24),
                    RatingNotesSection(controller: _notesController, maxLength: _maxNoteLength, onChanged: () => setState(() {})),
                  ],
                ],
              ),
            ),
          ),
          _buildBottomButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => Container(
        color: AppColors.white,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Padding(
              padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp, color: const Color(0xFF0E0E0E))),
                  Text('تقييم الرحلة', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s20)),
                  Icon(Icons.info_outline_rounded, size: 24.sp, color: const Color(0xFF0E0E0E)),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF5F5F5)),
          ],
        ),
      );

  Widget _buildBottomButton(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s16)),
          boxShadow: [BoxShadow(color: const Color(0xFFCCCCCC).withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, -2))],
        ),
        padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s16),
        child: SizedBox(
          height: 48.h, width: double.infinity,
          child: ElevatedButton(
            onPressed: _rating == 0 ? null : () {
              final orderId = int.tryParse(widget.args?.orderId ?? '');
              if (orderId != null) {
                sl<RequestBloc>().add(RateProviderEvent(
                  requestId: orderId,
                  rating: _rating,
                  comment: _notesController.text.isNotEmpty ? _notesController.text : null,
                ));
              }
              Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary, disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
              foregroundColor: AppColors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)), elevation: 0,
            ),
            child: Text('إرسال التقييم', style: getBoldStyle(color: AppColors.white, fontSize: FontSize.s16)),
          ),
        ),
      );
}

