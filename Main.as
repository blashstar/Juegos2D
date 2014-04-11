package  {
	
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import com.greensock.TweenLite;
	
	
	public class Main extends MovieClip {
		
		private var timer:Timer;
		private var puntaje_txt:TextField;
		private var vidas_txt:TextField;
		
		private var puntos:int;
		private var vidas:int;
		
		public function Main() {
			timer = new Timer(1500);
			timer.addEventListener(TimerEvent.TIMER, crearMonstruos);
			timer.start();
			
			vidas = 30;
			
			puntaje_txt = new TextField;
			puntaje_txt.opaqueBackground = true;
			puntaje_txt.defaultTextFormat = new TextFormat("Arial", 16);
			puntaje_txt.text = "Puntaje: 0";
			puntaje_txt.textColor = 0xFFFFFF;
			puntaje_txt.height = puntaje_txt.textHeight * 1.5;
			
			vidas_txt = new TextField;
			vidas_txt.opaqueBackground = true;
			vidas_txt.defaultTextFormat = new TextFormat("Arial", 16);
			vidas_txt.text = "Vidas: 3";
			vidas_txt.textColor = 0xFFFFFF;
			vidas_txt.height = puntaje_txt.textHeight * 1.5;
			vidas_txt.x = stage.stageWidth - vidas_txt.width;
			
			puntos = 0;
			
			addChild(puntaje_txt);
			addChild(vidas_txt);
			
			stage.addEventListener(Event.ENTER_FRAME, mover);
		}
		
		private function mover(e:Event):void{
			var hijos:int = numChildren;
			if(hijos > 0){
				for(var i:int = 0; i < hijos; i++){
					var mc:MovieClip = getChildAt(i) as MovieClip;
					if(mc){
						mc.y += 0.5;
						
						if(mc.y >= stage.stageHeight){
							vidas--;
							
							vidas_txt.text = "Vidas: " + vidas.toString();
							
							removeChild(mc);
							
							hijos--
							
							if(vidas == 0){
								trace("Acabó");
								stage.removeEventListener(Event.ENTER_FRAME, mover);
								timer.stop();
							}
							
						}
					}
					
				}
			}
		}
		
		private function crearMonstruos(e:TimerEvent):void{
			var mod:int = timer.currentCount%3;
			
			var enemigo:MovieClip
			if(mod == 0){
				enemigo = new cuadrado();
				enemigo.tabIndex = 4;
				enemigo.name = "enemigo1";
			}
			else{
				enemigo = new triangulo();
				enemigo.tabIndex = 2;
				enemigo.name = "enemigo2";
			}
			
			enemigo.x = Math.random() * stage.stageWidth;
			enemigo.y = 0;
			
			enemigo.addEventListener(MouseEvent.CLICK, matar);
			
			addChild(enemigo);
		}
		
		private function matar(e:MouseEvent):void{
			var mc:MovieClip = e.currentTarget as MovieClip;
			var nombre:String = mc.name;
			//trace(mc.tabIndex);
			
			mc.tabIndex--;
			
			if(mc.tabIndex == 0){
				
				//removeChild(mc);
				mc.removeEventListener(MouseEvent.CLICK, matar);
				
				TweenLite.to(mc, 0.5, {alpha:0, onComplete:removeChild, onCompleteParams:[mc]});
				
				puntos++;
				
				puntaje_txt.text = "Puntaje: " + puntos.toString();
				
			}
			else{
				if(nombre == "enemigo1"){
					
					mc.scaleX = 1.5;
					mc.scaleY = 1.5;
					TweenLite.to(mc, 0.3, {x:"+50", scaleX:1, scaleY:1});
				}
				else{
					mc.scaleX = 1.5;
					mc.scaleY = 1.5;
					TweenLite.to(mc, 0.3, {rotation:"+50", scaleX:1, scaleY:1 });
				}
				
			}
		}
	}
	
}
