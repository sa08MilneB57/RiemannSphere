class ListMenu{
  int txtSize;
  ListItem[] items;
  int selectedIndex = 0;
  ListMenu(ListItem[] _items,int textSize){
    items = _items;
    txtSize = textSize;
  }
  
  boolean show(){//returns true on a new selection, return value can otherwise be ignored
    textAlign(CENTER,CENTER);
    textSize(txtSize);
    rectMode(CENTER);
    noStroke();
    for(int i=0; i<items.length;i++){
      ListItem item = items[i];
      if(item.mousedOver() && mousePressed){
        select(i);
        return true;
      }
      item.show(selectedIndex == i);
    }
    return false;
  }
  
  void select(int index){
    selectedIndex = index;
    items[index].onSelect();
  }
}

abstract class ListItem{
    PVector pos,size;
    color normal,hovered,selected;
    String label;
    ListItem(String lbl,PVector p,PVector s,float H, float S, float L){
      label = lbl;
      pos = p.copy();
      size = s.copy();
      normal = HSL(H,S,L,0.7);
      hovered = HSL(H,sqrt(S),sqrt(L),1f);
      selected = HSL(H,S*S*S,sqrt(sqrt(L)));
    }
    
    abstract void onSelect();
    abstract Object value();
    
    void show(boolean isSelected){
      if(mousedOver()){
        fill(hovered);
      }else if(isSelected){
        fill(selected);
      } else {
        fill(normal);
      }
      rect(pos.x,pos.y,size.x,size.y);
      fill(255);
      text(label,pos.x,pos.y - size.y/10);
    }
    boolean mousedOver(){
      float relX = abs(mouseX - pos.x);
      float relY = abs(mouseY - pos.y);
      return relX < size.x/2d && relY < size.y/2f;
    }
}


  
