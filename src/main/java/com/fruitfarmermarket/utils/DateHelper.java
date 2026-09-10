package com.fruitfarmermarket.utils;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.IsoFields;
import java.time.temporal.TemporalAdjusters;

public class DateHelper {

    public static DateRange getDateRange(String period) {
        LocalDate today = LocalDate.now(); // Lấy ngày hiện tại của hệ thống (VD: T9/2026)

        LocalDate currStart, currEnd, prevStart, prevEnd;

        if (period == null) period = "this_month"; // Mặc định là tháng này

        switch (period) {
            case "today":
                currStart = currEnd = today;
                prevStart = prevEnd = today.minusDays(1);
                break;

            case "yesterday":
                currStart = currEnd = today.minusDays(1);
                prevStart = prevEnd = today.minusDays(2);
                break;

            case "this_week":
                currStart = today.with(DayOfWeek.MONDAY);
                currEnd = today.with(DayOfWeek.SUNDAY);
                prevStart = currStart.minusWeeks(1);
                prevEnd = currEnd.minusWeeks(1);
                break;

            case "this_month":
                currStart = today.with(TemporalAdjusters.firstDayOfMonth());
                currEnd = today.with(TemporalAdjusters.lastDayOfMonth());
                prevStart = currStart.minusMonths(1);
                prevEnd = prevStart.with(TemporalAdjusters.lastDayOfMonth());
                break;

            case "this_quarter":
                int currentQuarter = today.get(IsoFields.QUARTER_OF_YEAR);
                currStart = today.with(IsoFields.DAY_OF_QUARTER, 1L);
                currEnd = currStart.plusMonths(2).with(TemporalAdjusters.lastDayOfMonth());

                prevStart = currStart.minusMonths(3);
                prevEnd = prevStart.plusMonths(2).with(TemporalAdjusters.lastDayOfMonth());
                break;

            case "this_year":
                currStart = today.with(TemporalAdjusters.firstDayOfYear());
                currEnd = today.with(TemporalAdjusters.lastDayOfYear());
                prevStart = currStart.minusYears(1);
                prevEnd = prevStart.with(TemporalAdjusters.lastDayOfYear());
                break;

            default: // Mặc định trả về 30 ngày qua nếu không khớp
                currEnd = today;
                currStart = today.minusDays(29);
                prevEnd = currStart.minusDays(1);
                prevStart = prevEnd.minusDays(29);
                break;
        }

        return new DateRange(currStart, currEnd, prevStart, prevEnd);
    }
}