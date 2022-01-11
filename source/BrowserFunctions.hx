#if mobile //This Supports IOS Too
package;

import flixel.FlxState;
import extension.webview.WebView;

using StringTools;

class BrowserFunctions extends WebView
{
    public var finishCallback:Void->Void = null;

    public static var StoragePath:String = lime.system.System.applicationStorageDirectory;

	public function new() {
	}

	public static function playVideo(path:String) {
        //i finded this on this site https://stackoverflow.com/questions/13332261/access-a-local-file-with-file-in-android
        if (sys.FileSystem.exists(path))//Android/Data Thing
        {
        	openURL('file://' + path + '.html');//this is how file shoud be in browser
        }
        else if (sys.FileSystem.exists(StoragePath + path))//Application Storage Check
        {
        	openURL('file:///android_asset/' + path + '.html');//this is how file shoud be in browser
        }
        else//if the video is null will not crash the game
        {
        	if (finishCallback != null)
				finishCallback();
        }
	}

	public static function openURL(url:String) {
		WebView.onClose = onClose;
		WebView.onURLChanging= onURLChanging;

		WebView.open(url, false, null, ['http://exitme(.*)']);
	}

	function onClose() {
        if (finishCallback != null)
			finishCallback();
	}

	function onURLChanging(url:String) {
		if (url == 'http://exitme/') 
            onClose(); // drity hack lol
	}

	override function update(elapsed:Float) {
		for (touch in FlxG.touches.list)
			if (touch.justReleased)
				onClose();

		super.update(elapsed);	
	}
}
#end