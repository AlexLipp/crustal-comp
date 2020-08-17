 WITH data AS (
         SELECT ad.sample_id,
            round(avg(
                CASE
                    WHEN adl.analyte_code::text = 'Al'::text AND a.ana_method_id <> 28 AND ad.determination_unit::text = 'wtpct'::text THEN ad.abundance
                    WHEN adl.analyte_code::text = 'Al'::text AND a.ana_method_id <> 28 AND ad.determination_unit::text = 'ppm'::text THEN ad.abundance / 10000::numeric
                    WHEN adl.analyte_code::text = 'Al2O3'::text AND a.ana_method_id <> 28 AND ad.determination_unit::text = 'wtpct'::text THEN ad.abundance * 0.529251
                    ELSE NULL::numeric
                END), 4) AS al_wtpct,
            round(avg(
                CASE
                    WHEN adl.analyte_code::text = 'Ca'::text AND a.ana_method_id <> 28 AND ad.determination_unit::text = 'wtpct'::text THEN ad.abundance
                    WHEN adl.analyte_code::text = 'Ca'::text AND a.ana_method_id <> 28 AND ad.determination_unit::text = 'ppm'::text THEN ad.abundance / 10000::numeric
                    WHEN adl.analyte_code::text = 'CaO'::text AND a.ana_method_id <> 28 AND ad.determination_unit::text = 'wtpct'::text THEN ad.abundance * 0.714701
                    WHEN adl.analyte_code::text = 'CaO'::text AND a.ana_method_id <> 28 AND ad.determination_unit::text = 'ppm'::text THEN ad.abundance * 0.714701 / 10000::numeric
                    ELSE NULL::numeric
                END), 4) AS ca_wtpct,
            round(avg(
                CASE
                    WHEN adl.analyte_code::text = 'Fe'::text AND a.ana_method_id <> 28 AND ad.determination_unit::text = 'wtpct'::text THEN ad.abundance
                    WHEN adl.analyte_code::text = 'Fe'::text AND a.ana_method_id <> 28 AND ad.determination_unit::text = 'ppm'::text THEN ad.abundance / 10000::numeric
                    WHEN adl.analyte_code::text = 'Fe2O3'::text AND a.ana_method_id <> 28 AND ad.determination_unit::text = 'wtpct'::text THEN ad.abundance * 0.699433
                    WHEN adl.analyte_code::text = 'FeO'::text AND a.ana_method_id <> 28 AND ad.determination_unit::text = 'wtpct'::text THEN ad.abundance * 0.7773
                    ELSE NULL::numeric
                END), 4) AS fe_wtpct,
            round(avg(
                CASE
                    WHEN adl.analyte_code::text = 'K'::text AND a.ana_method_id <> 28 AND ad.determination_unit::text = 'wtpct'::text THEN ad.abundance
                    WHEN adl.analyte_code::text = 'K'::text AND a.ana_method_id <> 28 AND ad.determination_unit::text = 'ppm'::text THEN ad.abundance / 10000::numeric
                    WHEN adl.analyte_code::text = 'K2O'::text AND a.ana_method_id <> 28 AND ad.determination_unit::text = 'wtpct'::text THEN ad.abundance * 0.830147
                    WHEN adl.analyte_code::text = 'K2O'::text AND a.ana_method_id <> 28 AND ad.determination_unit::text = 'ppm'::text THEN ad.abundance * 0.830147 / 10000::numeric
                    ELSE NULL::numeric
                END), 4) AS k_wtpct,
            round(avg(
                CASE
                    WHEN adl.analyte_code::text = 'Mg'::text AND a.ana_method_id <> 28 AND ad.determination_unit::text = 'wtpct'::text THEN ad.abundance
                    WHEN adl.analyte_code::text = 'Mg'::text AND a.ana_method_id <> 28 AND ad.determination_unit::text = 'ppm'::text THEN ad.abundance / 10000::numeric
                    WHEN adl.analyte_code::text = 'MgO'::text AND a.ana_method_id <> 28 AND ad.determination_unit::text = 'wtpct'::text THEN ad.abundance * 0.603036
                    WHEN adl.analyte_code::text = 'MgO'::text AND a.ana_method_id <> 28 AND ad.determination_unit::text = 'ppm'::text THEN ad.abundance * 0.603036 / 10000::numeric
                    ELSE NULL::numeric
                END), 4) AS mg_wtpct,
            round(avg(
                CASE
                    WHEN adl.analyte_code::text = 'Na'::text AND a.ana_method_id <> 28 AND ad.determination_unit::text = 'wtpct'::text THEN ad.abundance
                    WHEN adl.analyte_code::text = 'Na'::text AND a.ana_method_id <> 28 AND ad.determination_unit::text = 'ppm'::text THEN ad.abundance / 10000::numeric
                    WHEN adl.analyte_code::text = 'Na2O'::text AND a.ana_method_id <> 28 AND ad.determination_unit::text = 'wtpct'::text THEN ad.abundance * 0.741857
                    ELSE NULL::numeric
                END), 4) AS na_wtpct,
            round(avg(
                CASE
                    WHEN adl.analyte_code::text = 'Si'::text AND a.ana_method_id <> 28 AND ad.determination_unit::text = 'wtpct'::text THEN ad.abundance
                    WHEN adl.analyte_code::text = 'Si'::text AND a.ana_method_id <> 28 AND ad.determination_unit::text = 'ppm'::text THEN ad.abundance / 10000::numeric
                    WHEN adl.analyte_code::text = 'SiO2'::text AND a.ana_method_id <> 28 AND ad.determination_unit::text = 'wtpct'::text THEN ad.abundance * 0.467439
                    ELSE NULL::numeric
                END), 4) AS si_wtpct
           FROM analyte_determination ad
             LEFT JOIN analyte_determination_limits adl ON adl.limit_id = ad.limit_id
             LEFT JOIN analysis a ON a.analysis_id = adl.analysis_id
          GROUP BY ad.sample_id
        )
 SELECT s.sample_id,
    s.original_num,
    s.height_depth_m,
    st.section_name,
    st.lat_dec,
    st.long_dec,
    dl.strat_name_long,
    dl.fm AS formation,
    e.env_bin AS dep_env_bin,
    dia.ics_name,
    ct.ct_name,
    dm.meta_name,
    dlth.lith_name,
    dlt.lith_texture,
    dlc.lith_composition,
    s.lith_notes,
    dc.color_name_full AS color,
    s.munsell_code,
    ia.interpreted_age,
    ia.min_age,
    ia.max_age,
    d.al_wtpct,
    d.ca_wtpct,
    d.fe_wtpct,
    d.k_wtpct,
    d.mg_wtpct,
    d.na_wtpct,
    d.si_wtpct
   FROM data d
     LEFT JOIN sample s ON s.sample_id = d.sample_id
     LEFT JOIN collecting_event ce ON s.coll_event_id = ce.coll_event_id
     LEFT JOIN site st ON st.site_id = ce.site_id
     LEFT JOIN craton_terrane ct ON ct.craton_terrane_id = st.craton_terrane_id
     LEFT JOIN dic_meta dm ON st.metamorphic_bin = dm.meta_id
     LEFT JOIN interpreted_age ia ON ia.sample_id = s.sample_id
     LEFT JOIN geol_context gc ON gc.geol_context_id = s.geol_context_id
     LEFT JOIN environment e ON e.env_id = gc.env_id
     LEFT JOIN geol_age ga ON ga.age_id = gc.age_id
     LEFT JOIN lithostrat l ON l.lithostrat_id = gc.lithostrat_id
     LEFT JOIN dic_lithostrat dl ON dl.strat_id = l.strat_id
     LEFT JOIN sample_context sc ON sc.sample_id = s.sample_id
     LEFT JOIN dic_ics_age dia ON dia.ics_id = ga.ics_id
     LEFT JOIN dic_lithology dlth ON dlth.lith_id = s.lith_id
     LEFT JOIN dic_lith_texture dlt ON dlt.lith_texture_id = s.lith_texture_id
     LEFT JOIN dic_lith_composition dlc ON dlc.lith_composition_id = s.lith_composition_id
     LEFT JOIN dic_color dc ON dc.color_id = s.color_id
  WHERE d.al_wtpct IS NOT NULL AND d.ca_wtpct IS NOT NULL AND d.fe_wtpct IS NOT NULL AND d.k_wtpct IS NOT NULL AND d.mg_wtpct IS NOT NULL AND d.na_wtpct IS NOT NULL AND d.si_wtpct IS NOT NULL
  ORDER BY s.sample_id;

