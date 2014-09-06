package com.appspot.typeonetwo.models;

import java.util.Date;

public class Insulin {
    public static final int RAPIDACTING = 0;
    public static final int LONGACTING = 1;
    int type;
    float dose;
    Date date;

    public Insulin(int type, float dose, Date date) {
        this.type = type;
        this.dose = dose;
        this.date = date;
    }

}
