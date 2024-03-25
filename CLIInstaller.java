import com.github.dcevm.installer.ConfigurationInfo;
import com.github.dcevm.installer.Installer;

import java.io.IOException;
import java.nio.file.Paths;

public class CLIInstaller {
    public static void main(String[] args) throws IOException {
        if (args.length != 3) {
            throw new RuntimeException("Usage: CLIInstaller <LINUX/WINDOWS/MAC_OS> <path to JRE root> <64/32>");
        }
        Installer installer = new Installer(ConfigurationInfo.valueOf(args[0]));
        installer.install(
                Paths.get(args[1]),
                args[2].equals("64"),
                false
        );
        System.out.println("Installer finished.");
    }
}
