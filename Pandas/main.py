import os
import pandas as pd
import logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s')

INPUT_DIR = 'input'
OUTPUT_DIR = 'output'

os.makedirs(INPUT_DIR, exist_ok=True)
os.makedirs(OUTPUT_DIR, exist_ok=True)
os.chmod(OUTPUT_DIR, 0o777)

sample_metadata = pd.DataFrame({
    'sample_id': ['Sample_1', 'Sample_2', 'Sample_3', 'Sample_4', 'Sample_5', 'Sample_6'],
    'cell_type': ['HEK293', 'HeLa', 'HEK293', 'U2OS', 'HeLa', 'Primary'],
    'treatment': ['Control', 'Drug_A', 'Drug_B', 'Control', 'Drug_A', 'Drug_C'],
    'replicate': [1, 1, 1, 2, 2, 1],
    'concentration_uM': [0, 10, 50, 0, 10, 100]
})


mass_spec_results = pd.DataFrame({
    'sample_id': ['Sample_1', 'Sample_2', 'Sample_3', 'Sample_4', 'Sample_7'],
    'total_proteins': [2450, 2310, 2540, 2480, 2600],
    'unique_peptides': [15200, 14800, 15600, 15400, 16200],
    'contamination_level': [0.02, 0.05, 0.03, 0.01, 0.04]
})


quality_metrics = pd.DataFrame({
    'sample_id': ['Sample_2', 'Sample_3', 'Sample_4', 'Sample_5', 'Sample_8'],
    'rin_score': [8.5, 7.2, 9.1, 6.8, 8.9],
    'pcr_duplication': [0.12, 0.18, 0.09, 0.25, 0.11],
    'mapping_rate': [0.95, 0.87, 0.96, 0.82, 0.94]
})

sample_metadata.to_csv(f"{INPUT_DIR}/sample_metadata.csv", index=False)
mass_spec_results.to_csv(f"{INPUT_DIR}/mass_spec_results.csv", index=False)
quality_metrics.to_csv(f"{INPUT_DIR}/quality_metrics.csv", index=False)

meta = pd.read_csv(f"{INPUT_DIR}/sample_metadata.csv")
ms = pd.read_csv(f"{INPUT_DIR}/mass_spec_results.csv")
quality = pd.read_csv(f"{INPUT_DIR}/quality_metrics.csv")

logging.info("Начинаем выполнение join-ов")

# INNER JOIN
inner_join = pd.merge(meta, ms, on='sample_id', how='inner')
inner_join = pd.merge(inner_join, quality, on='sample_id', how='inner')
logging.info(f"INNER JOIN: {len(inner_join)} строк")
inner_join.to_csv(f"{OUTPUT_DIR}/inner_join.csv", index=False)

# LEFT JOIN
left_join = pd.merge(meta, ms, on='sample_id', how='left')
left_join = pd.merge(left_join, quality, on='sample_id', how='left')
logging.info(f"LEFT JOIN: {len(left_join)} строк")
left_join.to_csv(f"{OUTPUT_DIR}/left_join.csv", index=False)

# RIGHT JOIN
right_join = pd.merge(meta, ms, on='sample_id', how='right')
right_join = pd.merge(right_join, quality, on='sample_id', how='right')
logging.info(f"RIGHT JOIN: {len(right_join)} строк")
right_join.to_csv(f"{OUTPUT_DIR}/right_join.csv", index=False)

# OUTER JOIN
outer_join = pd.merge(meta, ms, on='sample_id', how='outer')
outer_join = pd.merge(outer_join, quality, on='sample_id', how='outer')
logging.info(f"OUTER JOIN: {len(outer_join)} строк")
outer_join.to_csv(f"{OUTPUT_DIR}/outer_join.csv", index=False)
