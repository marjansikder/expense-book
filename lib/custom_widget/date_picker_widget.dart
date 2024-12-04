/*
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:expense_book/style_resources/colors.dart';
import 'package:flutter/material.dart';


final config = CalendarDatePicker2WithActionButtonsConfig(
  calendarType: CalendarDatePicker2Type.range,
  firstDayOfWeek: 0,
  lastDate: DateTime.now(),
  centerAlignModePicker: false,
  closeDialogOnCancelTapped: false,
  gapBetweenCalendarAndButtons: 10,
  selectedDayHighlightColor: kPrimaryColor,
  selectedRangeHighlightColor: kPrimaryColor,
  controlsTextStyle: FontUtil.blackW400S14,
  dayTextStyle: FontUtil.blackW400S12,
  selectedDayTextStyle: FontUtil.whiteW600S12,
  selectedRangeDayTextStyle: FontUtil.whiteW600S12,
);

class DatePickerFieldWidget extends ConsumerWidget {
  const DatePickerFieldWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateRange = ref.watch(reportDateRangeProvider);

    return InkWell(
      onTap: () {
        showCalendarDatePickerDialog(
          context: context,
          config: config,
          value: dateRange,
          dialogSize: const Size(400, 400),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          splashFactory: InkSplash.splashFactory,
          onCancelTapped: () {
            ref.read(reportDateRangeProvider.notifier).state = [DateTime.now()];
          },
          onOkTapped: (List<DateTime?> dates, _) {
            if (dates.isNotEmpty) {
              ref.read(reportDateRangeProvider.notifier).state = dates;
            } else {
              ref.read(reportDateRangeProvider.notifier).state = [DateTime.now()];
            }
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kBorderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (dateRange.isNotEmpty) ...[
              if (dateRange.length == 1) ...[
                Text(
                  DateUtil.formatDateTime4(dateRange[0])!,
                  style: FontUtil.blackW500S15,
                ),
              ] else ...[
                Text(
                  '${DateUtil.formatDateTime4(dateRange[0])} - ${DateUtil.formatDateTime4(dateRange[1])}',
                  style: FontUtil.blackW500S15,
                ),
              ],
            ],
            SvgImage.asset('assets/icons/ic_calender.svg', color: kPrimaryColor, size: 18),
          ],
        ),
      ),
    );
  }
}
*/
