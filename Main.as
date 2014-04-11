package  {
	
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import com.greensock.TweenLite;
	import com.greensock.plugins.ColorMatrixFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import flash.display.Shape;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.media.SoundChannel;
	
	TweenPlugin.activate([ColorMatrixFilterPlugin]);
	
	public class Main extends MovieClip {
		
		private var timer:Timer;
		private var puntaje_txt:TextField;
		private var vidas_txt:TextField;
		
		private var puntos:int;
		private var vidas:int;
		
		private var inicio:MovieClip;
		private var sndMuere:Sound;
		private var sndBala:Sound;
		
		public function Main() {
			inicio = new Home() as MovieClip;
			inicio.y = -inicio.height;
			TweenLite.to(inicio, 0.5, {y:0});
			addChild(inicio);
			inicio.botonJugar.addEventListener(MouseEvent.CLICK, btnJugarClick);
			inicio.botonJugar.buttonMode = true;
			
			var fondo:Shape = new Shape();
			fondo.graphics.beginFill(0xFFFFFF);
			fondo.graphics.drawRect(0,0,800,600);
			fondo.graphics.endFill();
			addChildAt(fondo, 0);
			
			sndMuere = new Sound();
			sndMuere.load(new URLRequest("sounds/62386__fons__eng-1.mp3"));
			
			sndBala = new Sound();
			sndBala.load(new URLRequest("sounds/220612__senitiel__pistol2.mp3"));
		}
			
		private function btnJugarClick(e:MouseEvent):void{
			TweenLite.to(inicio, 0.5, {y:-inicio.height, onComplete:iniciaJuego});
		}
		
		private function iniciaJuego(){
			removeChild(inicio);
			
			var sndFondo:Sound = new Sound();
			sndFondo.load(new URLRequest("sounds/hell-Mike_Koenig-144950046.mp3"));
			//var chnFondo:SoundChannel = sndFondo.play();
			
			crearTimer();
			crearCarteles();
			
			stage.addEventListener(Event.ENTER_FRAME, mover);
		}
		
		private function crearTimer(){
			timer = new Timer(1500);
			timer.addEventListener(TimerEvent.TIMER, crearMonstruos);
			timer.start();
		}
		
		private function crearCarteles(){
			vidas = 100;
			puntos = 0;
			
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
			
			addChild(puntaje_txt);
			addChild(vidas_txt);
		}
		
		private function mover(e:Event):void{
			var hijos:int = numChildren;
			if(hijos > 0){
				for(var i:int = 0; i < hijos; i++){
					var mc:MovieClip = getChildAt(i) as MovieClip;
					if(mc){
						mc.x += 1;
						
						if(mc.x >= stage.stageWidth){
							vidas--;
							
							vidas_txt.text = "Vidas: " + vidas.toString();
							
							removeChild(mc);
							
							TweenLite.to(this, 0.5, {colorMatrixFilter:{colorize:0xff0000, amount:0.5}, onComplete:regresarEstado});
							
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
			
			enemigo.y = Math.random() * stage.stageHeight;
			enemigo.x = 0;
			
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
				
				TweenLite.to(mc, 0.5, {alpha:0, scaleX:0, scaleY:0, onComplete:removeChild, onCompleteParams:[mc]});
				
				puntos++;
				
				puntaje_txt.text = "Puntaje: " + puntos.toString();
				
				sndMuere.play();
				
			}
			else{
				sndBala.play();
				if(nombre == "enemigo1"){
					
					mc.scaleX = 0.5;
					mc.scaleY = 0.5;
					TweenLite.to(mc, 0.3, {y:"+10", scaleX:1, scaleY:1});
				}
				else{
					mc.scaleX = 0.5;
					mc.scaleY = 0.5;
					TweenLite.to(mc, 0.3, {rotation:"+30", scaleX:1, scaleY:1 });
				}
				
			}
		}
		
		private function regresarEstado(){
			TweenLite.to(this, 0.5, {colorMatrixFilter:{colorize:0xff0000, amount:0}});
							
		}
		
	}
	
}
