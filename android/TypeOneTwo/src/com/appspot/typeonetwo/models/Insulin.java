package com.appspot.typeonetwo.models;

import java.util.Date;

public class Insulin {
    InsulinType type;
    float dose;
    Date date;

    public Insulin(InsulinType type, float dose, Date date) {
        this.type = type;
        this.dose = dose;
        this.date = date;
    }

    private enum InsulinType {
        RAPIDACTING, LONGACTING
    }
}
