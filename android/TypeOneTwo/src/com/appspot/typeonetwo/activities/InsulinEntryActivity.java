package com.appspot.typeonetwo.activities;

import java.util.Locale;

import android.app.Dialog;
import android.app.DialogFragment;
import android.app.DatePickerDialog;
import android.app.TimePickerDialog;
import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.util.Log;
import android.widget.DatePicker;
import android.widget.TimePicker;

import java.util.Calendar;
import java.util.Date;

import com.appspot.typeonetwo.models.Insulin;

public class InsulinEntryActivity extends Activity {

    private Insulin insulin;
    private Date insulinDate;
    private static int year, month, day, hour, minute, insulinType;
    private static boolean dateClicked = false;
    private static boolean timeClicked = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_insulin_entry);
    }

    public void showTimePicker(View v) {
        DialogFragment f = new TimePickerFragment();
        f.show(getFragmentManager(), "date_picker");
    }

    public void showDatePicker(View v) {
        DialogFragment f = new DatePickerFragment();
        f.show(getFragmentManager(), "time_picker");
    }

    public void submitInsulinForm(View v) {
        //insulin = new Insulin(Insulin.InsulinType.
        Log.d("swiggins", ""+year);
        Log.d("swiggins", ""+month);
        Log.d("swiggins", ""+day);
        Log.d("swiggins", ""+hour);
        Log.d("swiggins", ""+minute);
    }

    public void onRapidActingClicked(View v) {
        insulinType = 0;
    }

    public void onLongActingClicked(View v) {
        insulinType = 1;
    }

    private static class TimePickerFragment extends DialogFragment implements TimePickerDialog.OnTimeSetListener {

        @Override
        public Dialog onCreateDialog(Bundle savedInstanceState) {
            timeClicked = true;

            final Calendar cal = Calendar.getInstance();

            hour = cal.get(Calendar.HOUR_OF_DAY);
            minute = cal.get(Calendar.MINUTE);

            return new TimePickerDialog(getActivity(), this, hour, minute, false);
        }

        public void onTimeSet(TimePicker view, int selectedHour, int selectedMinute) {
            hour = selectedHour;
            minute = selectedMinute;
        }

    }

    private static class DatePickerFragment extends DialogFragment implements DatePickerDialog.OnDateSetListener {

        @Override
        public Dialog onCreateDialog(Bundle savedInstanceState) {
            dateClicked = true;

            final Calendar cal = Calendar.getInstance();

            year = cal.get(Calendar.YEAR);
            month = cal.get(Calendar.MONTH);
            day = cal.get(Calendar.DAY_OF_MONTH);

            return new DatePickerDialog(getActivity(), this, year, month, day);
        }

        public void onDateSet(DatePicker view, int selectedYear, int selectedMonth, int selectedDay) {
            year = selectedYear;
            month = selectedMonth;
            day = selectedDay;
        }

    }

}

