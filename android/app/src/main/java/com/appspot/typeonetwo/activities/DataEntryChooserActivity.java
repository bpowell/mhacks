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

import org.androidannotations.annotations.AfterViews;
import org.androidannotations.annotations.EActivity;

@EActivity(R.layout.activity_data_entry_chooser)
public class DataEntryChooserActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @AfterViews
    void init() {
        ActionBar actionBar = getActionBar();
        actionBar.setDisplayHomeAsUpEnabled(true);
    }

    public void onInsulinChosen(View v) {
        InsulinEntryActivity_
                .intent(this)
                .start();
    }

    public void onGlucoseChosen(View v) {
        GlucoseEntryActivity_
                .intent(this)
                .start();
    }

}
