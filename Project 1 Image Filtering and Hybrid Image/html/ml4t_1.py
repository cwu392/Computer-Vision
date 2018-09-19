import pandas as pd

def get_max_close(symbol):
	df=pd.read_csv("data/{}.csv".format(symbol))
	return df['Close'].max()

def test_run():
	for symbol in ['AAPL','IBM']:
		print("Max close")
		print(symbol,get_max_close(symbol))

if name == "__main__":
	test_run()