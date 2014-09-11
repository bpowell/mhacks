package com.appspot.typeonetwo.activities;

import android.app.ActionBar;
import android.app.Dialog;
import android.app.DialogFragment;
import android.app.DatePickerDialog;
import android.app.TimePickerDialog;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Toast;
import android.widget.EditText;
import android.widget.DatePicker;
import android.widget.TimePicker;

import java.util.Calendar;
import java.util.Date;

import com.appspot.typeonetwo.activities.MainActivity;
import com.appspot.typeonetwo.models.Insulin;

import com.appspot.typeonetwo.R;

import com.parse.*;

import org.androidannotations.annotations.AfterViews;
import org.androidannotations.annotations.EActivity;

@EActivity(R.layout.activity_insulin_entry)
public class InsulinEntryActivity extends Activity {

    private Insulin insulin;
    private Date insulinDate;
    private static Integer year, month, day, hour, minute, insulinType;
    private static boolean dateClicked = false;
    private static boolean timeClicked = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @AfterViews
        void init() {
        ActionBar actionBar = getActionBar();
        actionBar.setDisplayHomeAsUpEnabled(true);
    }

    public void showTimePicker(View v) {
        DialogFragment f = new TimePickerFragment();
        f.show(getFragmentManager(), "date_picker");
    }

    public void showDatePicker(View v) {
        DialogFragment f = new DatePickerFragment();
        f.show(getFragmentManager(), "time_picker");
    }

    public void submitInsulinForm() {
        if (year        == null ||
            month       == null ||
            day         == null ||
            hour        == null ||
            minute      == null ||
            insulinType == null) {
            Toast.makeText(getApplicationContext(), "Please fill out the form.", Toast.LENGTH_SHORT);
        } else {

            EditText dose = (EditText) findViewById(R.id.insulinDose);

            Calendar cal = Calendar.getInstance();
            cal.set(Calendar.YEAR, year);
            cal.set(Calendar.MONTH, month);
            cal.set(Calendar.DAY_OF_MONTH, day);
            cal.set(Calendar.HOUR, hour);
            cal.set(Calendar.MINUTE, minute);

            ParseObject insulin = new ParseObject("Insulin");
            insulin.put("type", ((insulinType == 0) ? Insulin.RAPIDACTING : Insulin.LONGACTING));
            insulin.put("dose", Float.parseFloat(dose.getText().toString()));
            insulin.put("date", cal.getTime());
            insulin.saveInBackground();

            MainActivity_
                    .intent(this)
                    .start();

        }
    }

    public void onRapidActingClicked(View v) {
        insulinType = 0;
    }

    public void onLongActingClicked(View v) {
        insulinType = 1;
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.accept, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();
        if (id == R.id.action_accept) {
            submitInsulinForm();
            return true;
        }
        return super.onOptionsItemSelected(item);
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

