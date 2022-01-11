#if mobile //This Supports IOS Too
package;

import flixel.FlxState;
import flixel.FlxBasic;
import extension.webview.WebView;

using StringTools;

class BrowserFunctions extends FlxBasic {
    public var finishCallback:Void->Void = null;

    public static var StoragePath:String = lime.system.System.applicationStorageDirectory;

	public function new() {
		super();
	}

	public function playVideo(path:String) {
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

	public function openURL(url:String) {
		WebView.onClose = onClose;
		WebView.onURLChanging= onURLChanging;

		WebView.open(url, false, null, ['http://exitme(.*)']);
	}

	public override function update(elapsed:Float) {
		for (touch in flixel.FlxG.touches.list)
			if (touch.justReleased)
				onClose();

		super.update(elapsed);	
	}

	function onClose() {
        if (finishCallback != null)
			finishCallback();
	}

	function onURLChanging(url:String) {
		if (url == 'http://exitme/') 
            onClose(); // drity hack lol
	}
}
#end
