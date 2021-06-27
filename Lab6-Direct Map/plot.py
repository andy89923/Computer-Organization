import matplotlib.pyplot as plt
import subprocess


associativity_l = [1, 2, 4, 8, 16, 32]
cacheSize_l = [2, 4, 8, 16]
blockSize_l = [2, 4, 8, 16, 64, 128, 512]

def fix_associativity(associativity: int):
	print("Fix associativity to:", associativity)

	plt.title(f'Associativity = {associativity}')
	plt.xlabel('Block size')
	plt.ylabel('Miss rate%')
	for cache_size in cacheSize_l:
		x = []
		y = []
		for block_size in blockSize_l:
			cmd = [
				'./cache_simulator', '-f', 'Trace.txt', 
				'-c', str(cache_size), '-a', str(associativity), '-b', str(block_size),
				'-l', '0', '-k', '1'
			]
			out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')

			y.append(int(out[-4:-2]))
			x.append(f"{block_size} bytes")

		plt.plot(x, y, label = f"{cache_size} KB")
		plt.xticks(x)

	plt.legend(title = 'Cache size', loc = 'upper right')
	plt.savefig(f"Fix associativity to {associativity}-way")
	plt.show()


def fix_blockSize(blockSize: int):
	print("Fix block size to:", blockSize)

	plt.title(f'Block size = {blockSize} B')
	plt.xlabel('Associativity')
	plt.ylabel('Miss rate%')

	for cache_size in cacheSize_l:
		x = []
		y = []
		for now_asso in associativity_l:
			cmd = [
				'./cache_simulator', '-f', 'Trace.txt', 
				'-c', str(cache_size), '-a', str(now_asso), '-b', str(blockSize),
				'-l', '0'
			]
			out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
			x.append(f"{now_asso} way")
			y.append(int(out[-4:-2]))

		plt.plot(x, y, label = f"{cache_size} KB")
		plt.xticks(x)

	plt.legend(title = 'Cache size', loc = 'upper right')
	plt.savefig(f"Fix block size to {blockSize}B")
	plt.show()


def main():
	print("Start Simulate....")

	fix_associativity(1)
	fix_blockSize(32)

if __name__ == "__main__":
	main()