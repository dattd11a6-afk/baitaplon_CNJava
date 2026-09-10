package com.fruitfarmermarket.utils;

import java.time.LocalDate;

public class DateRange {
    private LocalDate currentStart;
    private LocalDate currentEnd;
    private LocalDate previousStart;
    private LocalDate previousEnd;

    public DateRange(LocalDate currentStart, LocalDate currentEnd, LocalDate previousStart, LocalDate previousEnd) {
        this.currentStart = currentStart;
        this.currentEnd = currentEnd;
        this.previousStart = previousStart;
        this.previousEnd = previousEnd;
    }

    // Getters
    public LocalDate getCurrentStart() { return currentStart; }
    public LocalDate getCurrentEnd() { return currentEnd; }
    public LocalDate getPreviousStart() { return previousStart; }
    public LocalDate getPreviousEnd() { return previousEnd; }
}