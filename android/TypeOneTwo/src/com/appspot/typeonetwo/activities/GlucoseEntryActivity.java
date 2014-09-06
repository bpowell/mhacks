package com.appspot.typeonetwo.activities;

import android.app.ActionBar;
import android.app.Dialog;
import android.app.DialogFragment;
import android.app.DatePickerDialog;
import android.app.TimePickerDialog;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Toast;
import android.widget.EditText;
import android.widget.DatePicker;
import android.widget.TimePicker;

import java.util.Calendar;

import com.appspot.typeonetwo.activities.MainActivity;
import com.appspot.typeonetwo.models.Insulin;

import com.parse.*;

public class GlucoseEntryActivity extends Activity {

    private static Integer year, month, day, hour, minute;
    private static boolean dateClicked = false;
    private static boolean timeClicked = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_glucose_entry);

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

    public void submitGlucoseForm() {
        if (year        == null ||
            month       == null ||
            day         == null ||
            hour        == null ||
            minute      == null) {
            Toast.makeText(getApplicationContext(), "Please fill out the form.", Toast.LENGTH_SHORT);
        } else {

            EditText dose = (EditText) findViewById(R.id.glucoseLevel);

            Calendar cal = Calendar.getInstance();
            cal.set(Calendar.YEAR, year);
            cal.set(Calendar.MONTH, month);
            cal.set(Calendar.DAY_OF_MONTH, day);
            cal.set(Calendar.HOUR, hour);
            cal.set(Calendar.MINUTE, minute);

            ParseObject glucose = new ParseObject("Glucose");
            glucose.put("level", Float.parseFloat(dose.getText().toString()));
            glucose.put("date", cal.getTime());
            glucose.saveInBackground();

            Intent intent = new Intent(this, MainActivity.class);
            startActivity(intent);

        }
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
            submitGlucoseForm();
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
