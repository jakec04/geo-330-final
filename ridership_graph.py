import pandas as pd
import matplotlib.pyplot as plt

# load data
df = pd.read_json("https://data.cityofchicago.org/api/views/6iiy-9s97/rows.json?accessType=DOWNLOAD")

# parse dates
df['service_date'] = pd.to_datetime(df['service_date'])
df['year_month'] = df['service_date'].dt.to_period('M')

# group
monthly = df.groupby('year_month')['total_rides'].mean().reset_index()
monthly['year_month'] = monthly['year_month'].dt.to_timestamp()

# plot
plt.figure(figsize=(10,6))
plt.plot(monthly['year_month'], monthly['total_rides'], marker='o')
plt.title('CTA Average Daily Boardings by Month')
plt.xlabel('Month')
plt.ylabel('Average Daily Boardings')
plt.grid(True)
plt.tight_layout()
plt.show()
