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

app.whenReady().then(() => {
	createWindow();

	app.on('activate', function () {
		if (BrowserWindow.getAllWindows().length === 0) createWindow();
	});
});

app.on('window-all-closed', function () {
	if (process.platform !== 'darwin') app.quit();
});

ipcMain.handle('convert-fbx', async (event, inputPath) => {
	return new Promise((resolve, reject) => {
		const exePath = path.join(__dirname, 'FBX2glTF-windows-x64.exe');
		const outputPath = inputPath.replace(/\.fbx$/i, '_converted.glb');

		execFile(exePath, ['-i', inputPath, '-o', outputPath, '-b'], (error, stdout, stderr) => {
			if (error) {
				reject(error.message);
				return;
			}
			resolve(outputPath);
		});
	});
});