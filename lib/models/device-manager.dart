class DeviceManager {
	static bool isAdmin() {
		return const bool.fromEnvironment("ADMIN");
	}
}
