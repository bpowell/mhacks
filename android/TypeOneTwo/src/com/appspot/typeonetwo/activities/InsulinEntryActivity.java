package com.appspot.typeonetwo.activities;

import java.util.Locale;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;

import android.util.Log;
import android.widget.ToggleButton;

public class InsulinEntryActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_insulin_entry);
    }

    public void onToggleClicked(View v) {
        boolean on = ((ToggleButton) v).isChecked();
        Log.d("swiggins", "alskj"+on);
    }

}
