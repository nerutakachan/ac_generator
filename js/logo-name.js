// logo-name.js

/**
 * プロジェクトのデータフォルダからbadge.pngを表示する
 * @param {string} dataFolder - window.currentProject.environment.data_folder の値
 */
export const updateBadgeImage = (dataFolder) => {
	const badgeImg = document.getElementById('ui-badge');
	if (!badgeImg || !dataFolder) return;

	// ★修正：'/data/' が含まれている場合は削除して、直接 '/ui/badge.png' を繋ぐ
	const cleanFolder = dataFolder.replace(/\/data$/, '').replace(/\\data$/, '');
	const badgePath = `${cleanFolder}/ui/badge.png`.replace(/\\/g, '/');
	
	console.log("🛠 [Badge] 設定パス:", `file:///${badgePath}`);
	
	badgeImg.src = `file:///${badgePath}`;
};