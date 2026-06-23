const { app, BrowserWindow, ipcMain } = require('electron');
const path = require('path');
const { execFile } = require('child_process');

function createWindow() {
	const mainWindow = new BrowserWindow({
		width: 1200,
		height: 800,
		webPreferences: {
			nodeIntegration: true,
			contextIsolation: false
		}
	});
	mainWindow.loadFile('3d-fbx.html');
}

app.whenReady().then(createWindow);

app.on('window-all-closed', () => {
	if (process.platform !== 'darwin') app.quit();
});

ipcMain.handle('convert-fbx', async (event, inputPath) => {
	return new Promise((resolve, reject) => {
		const blenderExe = 'C:\\Program Files\\Blender Foundation\\Blender 5.1\\blender.exe';
		const scriptPath = path.join(__dirname, 'export_gltf.py');
		const outputPath = inputPath.replace(/\.fbx$/i, '_converted.glb');

		const args = ['--background', '--python', scriptPath, '--', inputPath, outputPath];

		execFile(blenderExe, args, (error, stdout, stderr) => {
      if (stdout) console.log("Blender stdout:", stdout);
      if (stderr) console.error("Blender stderr:", stderr);
      if (error) {
        console.error("Blender execution error:", error);
        return reject(error.message);
      }
      resolve(outputPath);
    });
	});
});
