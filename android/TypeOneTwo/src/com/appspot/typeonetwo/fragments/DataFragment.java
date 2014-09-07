package com.appspot.typeonetwo.fragments;

import android.app.Activity;
import android.app.ListFragment;
import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.appspot.typeonetwo.models.Glucose;
import com.appspot.typeonetwo.models.Insulin;

import java.util.Date;
import java.util.List;
import java.util.ArrayList;

import com.appspot.typeonetwo.activities.R;

import com.parse.*;

public class DataFragment extends ListFragment {

    private static ListView list;
    private static Context context;
    final static ArrayList<Object> diabetesList = new ArrayList<Object>();

    public DataFragment() { }

    public static DataFragment newInstance() {
        DataFragment dataFragment = new DataFragment();

        ParseQuery<ParseObject> insulinQuery = ParseQuery.getQuery("Insulin");
        insulinQuery.findInBackground(new FindCallback<ParseObject>() {
            public void done(List<ParseObject> insulinList, ParseException e) {
                if (e == null) {
                    for (int i = 0; i < insulinList.size(); i++) {
                        ParseObject object = insulinList.get(i);

                        int type = object.getInt("type");
                        double dose = object.getDouble("dose");
                        Date date = object.getDate("date");
                        Insulin insulin = new Insulin(type, dose, date);

                        diabetesList.add(insulin);
                    }
                } else {
                    //Toast.makeText(this, "FAILED", Toast.LENGTH_LONG);
                }
            }
        });

        ParseQuery<ParseObject> glucoseQuery = ParseQuery.getQuery("Glucose");
        glucoseQuery.findInBackground(new FindCallback<ParseObject>() {
            public void done(List<ParseObject> glucoseList, ParseException e) {
                if (e == null) {
                    for (int i = 0; i < glucoseList.size(); i++) {
                        ParseObject object = glucoseList.get(i);

                        Date date = object.getDate("date");
                        int level = object.getInt("level");

                        Glucose glucose = new Glucose(level, date);

                        diabetesList.add(glucose);
                    }
                } else {
                    //Toast.makeText(this, "FAILED", Toast.LENGTH_LONG);
                }
            }
        });

        DiabetesAdapter adapter = new DiabetesAdapter(context, diabetesList);

        list.setAdapter(adapter);

        return dataFragment;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.layout_data, container, false);

        context = container.getContext();

        list = (ListView) getActivity().findViewById(android.R.id.list);

        return v;
    }

    public static class DiabetesAdapter extends ArrayAdapter<Object> {

        public DiabetesAdapter(Context context, ArrayList<Object> diabetes) {
            super(context, R.layout.list_cell, diabetes);
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            Object object = getItem(position);

            if (convertView == null) {
                convertView = LayoutInflater.from(getContext()).inflate(R.layout.list_cell, parent, false);
            }

            TextView cellTitle = (TextView) convertView.findViewById(R.layout.list_cell);
            if (object instanceof Glucose) {
                cellTitle.setText("Glucose");
            } else {
                cellTitle.setText("Insulin");
            }

            return convertView;
        }
    }
}
