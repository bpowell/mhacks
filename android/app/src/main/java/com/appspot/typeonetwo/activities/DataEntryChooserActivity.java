package com.appspot.typeonetwo.activities;

import android.app.ActionBar;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import android.view.View;

import android.util.Log;

import com.appspot.typeonetwo.activities.InsulinEntryActivity;
import com.appspot.typeonetwo.activities.GlucoseEntryActivity;

import com.appspot.typeonetwo.R;

public class DataEntryChooserActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_data_entry_chooser);

        ActionBar actionBar = getActionBar();
        actionBar.setDisplayHomeAsUpEnabled(true);
    }

    public void onInsulinChosen(View v) {
        Intent intent = new Intent(this, InsulinEntryActivity.class);
        startActivity(intent);
    }

    public void onGlucoseChosen(View v) {
        Intent intent = new Intent(this, GlucoseEntryActivity.class);
        startActivity(intent);
    }

}
