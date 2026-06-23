import bpy
import sys

# コマンドライン引数からパスを取得
input_path = sys.argv[-2]
output_path = sys.argv[-1]

# 既存のシーンをクリア
bpy.ops.wm.read_factory_settings(use_empty=True)

# FBXの読み込み
bpy.ops.import_scene.fbx(filepath=input_path, use_anim=False)

# そのままGLBとしてエクスポート
bpy.ops.export_scene.gltf(
	export_apply=True,
	filepath=output_path,
	export_format='GLB'
)