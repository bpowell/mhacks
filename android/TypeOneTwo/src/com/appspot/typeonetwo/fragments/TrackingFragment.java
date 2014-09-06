package com.appspot.typeonetwo.fragments;

import android.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.appspot.typeonetwo.R;

public class TrackingFragment extends Fragment {

    public TrackingFragment() { }

    public static TrackingFragment newInstance() {
        TrackingFragment trackingFragment = new TrackingFragment();

        return trackingFragment;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, 
            Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.layout_tracking, container, false);

        return v;
    }
}
