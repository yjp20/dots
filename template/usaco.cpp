// $%U%$
// $%Y%$ $%M%$

#include <bits/stdc++.h>
#define by(x) [](const auto& a, const auto& b) { return a.x < b.x; }
#define byr(x) [](const auto& a, const auto& b) { return a.x > b.x; }
#define smax(a, b) ((a) < (b) ? ((a)=(b), true) : false)
#define smin(a, b) ((a) > (b) ? ((a)=(b), true) : false)
using namespace std;

typedef long long ll;

void setIO(string s) {
	ios_base::sync_with_stdio(0);
	cin.tie(0);
	cout << fixed << setprecision(9);
#ifndef TESTER
	freopen((s+".in").c_str(), "r", stdin);
#endif
#ifndef DEBUG
	freopen((s+".out").c_str(), "w", stdout);
#endif
}

int main() {
	setIO("");

	return 0;
}
