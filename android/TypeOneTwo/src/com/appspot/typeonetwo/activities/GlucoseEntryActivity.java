package com.appspot.typeonetwo.activities;

import java.util.Locale;

import android.app.ActionBar;
import android.app.Activity;
import android.os.Bundle;

public class GlucoseEntryActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_glucose_entry);

        ActionBar actionBar = getActionBar();
        actionBar.setDisplayHomeAsUpEnabled(true);
    }

}
