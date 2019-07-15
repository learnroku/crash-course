#  Lesson 4
## Parsing JSON, Data Driven UI
In this lesson we will refactor the feed loading to centralize the logic into `home_scene.brs`. We will also add a parser for the external JSON and display the feed as a grid of thumbnails.

OK, let's go:

1. In home_scene.brs, add update `init()`:
    ``` java

    function init()
    	? "[home_scene] init"
    	m.category_screen = m.top.findNode("category_screen")
    	m.content_screen = m.top.findNode("content_screen")

    	m.category_screen.observeField("category_selected", "onCategorySelected")
    	m.category_screen.setFocus(true)
    end function
    ```
    Notice the new `content_screen` reference, we'll get to that in a minute.  Right now let's deal with the field observer for the category screen. Update the rest of the file, essentially cutting and pasting the code from Lesson 3 into the home_scene:  

    ``` java

    sub onCategorySelected(obj)
        ? "onCategorySelected field: ";obj.getField()
        ? "onCategorySelected data: ";obj.getData()
        list = m.category_screen.findNode("category_list")
        ? "onCategorySelected checkedItem: ";list.checkedItem
        ? "onCategorySelected selected ContentNode: ";list.content.getChild(obj.getData())
        item = list.content.getChild(obj.getData())
        loadFeed(item.feed_url)
    end sub

    sub loadFeed(url)
      m.feed_task = createObject("roSGNode", "load_feed_task")
      m.feed_task.observeField("response", "onFeedResponse")
      m.feed_task.url = url
      m.feed_task.control = "RUN"
    end sub
    ```
    Notice the use of `findNode("category_list")`, this syntax looks up the RadioButtonList on the category screen to access the selected ContentNode.  
    Now all that is missing is the `onFeedResponse` handler for the feed data. Add this:

    ``` java

    sub onFeedResponse(obj)
    	response = obj.getData()
    	data = parseJSON(response)
    	if data <> Invalid and data.items <> invalid
            m.category_screen.visible = false
            m.content_screen.visible = true
    		m.content_screen.feed_data = data
    	else
    		? "FEED RESPONSE IS EMPTY!"
    	end if
    end sub
    ```

    Pay attention to the `visible` value on the screens. This logic hides the category list, and shows the content grid. Also notice the use of `parseJSON()`, this is a global method that will convert a JSON string into an Associative Array.

1. Go back into `category_screen.brs` and delete all the code so you are left with just the `init()` function:
    ``` java

    function init()
        m.category_list=m.top.findNode("category_list")
        m.category_list.setFocus(true)
    end function
    ```
    Then open `category_screen.xml` and add a field the interface:  
    ``` xml
    <interface>
      <field id="category_selected"
              type="assocarray"
              alias="category_list.itemSelected"
          />
    </interface>
    ```  
    The `alias` attribute allows the component to expose a child's field.  This will allow the home_scene to observe the list changes.  
    Here are the docs: https://sdkdocs.roku.com/display/sdkdoc/interface

1.  The next steps will create the `content_screen` referenced above. Open `home_scene.xml` and update it to include the new child:  
    ``` xml
    <?xml version="1.0" encoding="utf-8" ?>
    <component name="home_scene" extends="Scene" initialFocus="category_screen">
      <script type="text/brightscript" uri="pkg:/components/home_scene.brs" />
      <children>
        <category_screen
          id="category_screen"
          visible="true"
          translation="[0,0]" />
        <content_screen
          id="content_screen"
          visible="false"
          translation="[0,0]" />
      </children>
    </component>
    ```

    In the `components/screens` directory, create a file `content_screen.xml` and add the following:
    ``` xml
    <?xml version="1.0" encoding="utf-8" ?>
    <component   name="content_screen"   extends="Group"   initialFocus="content_grid" >
        <script type="text/brightscript" uri="pkg:/components/screens/content_screen.brs" />
        <interface>
          <field id="feed_data"
              type="assocarray"
              onChange="onFeedChanged"
              />
        </interface>
        <children>
            <Label
            translation="[75, 75]"
              id="header"
              color="0xFFFFFF"
              font="font:LargeBoldSystemFont"
              text=""/>
            <PosterGrid
              id="content_grid"
              translation="[100,175]"
              basePosterSize="[500,280]"
              itemSpacing="[110,110]"
              caption1NumLines="1"
              caption2NumLines="1"
              numColumns="3"
              numRows="4"
              />
        </children>
    </component>
    ```  

    Create the companion file `content_screen.brs` and add the following:  

    ``` java

    sub init()
        m.content_grid = m.top.FindNode("content_grid")
        m.header = m.top.FindNode("header")
    end sub  

    sub onFeedChanged(obj)
        feed = obj.getData()
        m.header.text = feed.title
        postercontent = createObject("roSGNode","ContentNode")
        for  i=0 to 5 step 1
            node = createObject("roSGNode","ContentNode")
            node.HDGRIDPOSTERURL = "http://10.0.0.42:8888/roku_lessons/images/thumbnail-comedy1.jpg"
            node.SHORTDESCRIPTIONLINE1 = "ITEM No. "+ i.toStr()
            node.SHORTDESCRIPTIONLINE2 = "This is a description."
            postercontent.appendChild(node)
        end for
        showpostergrid(postercontent)
    end sub  

    sub showpostergrid(content)
      m.content_grid.content=content
      m.content_grid.visible=true
      m.content_grid.setFocus(true)
    end sub
    ```  

    This code creates some placeholder data to verify the PosterGrid is rendering correctly. The pattern is very similar to the data provided to the category list. There is a single parent node, then a `for` loop creates some dummy nodes to populate it.  
    Run the app and select a category, a grid of content should appear with the title from the JSON at the top of the screen:  
    <img src="screenshots/l4_contenttest.png" width="400"/>

1. Finally, edit the `onFeedChanged()` function to use the data provided by the feed. Some of these properties will be used later when video playback is added to the app.
    ``` java
    
    sub onFeedChanged(obj)
        feed = obj.getData()
        m.header.text = feed.title
        postercontent = createObject("roSGNode","ContentNode")
        for each item in feed.items
            node = createObject("roSGNode","ContentNode")
            node.streamformat = item.streamformat
            node.title = item.title
            node.url = item.url
            node.description = item.description
            node.HDGRIDPOSTERURL = item.thumbnail
            node.SHORTDESCRIPTIONLINE1 = item.title
            node.SHORTDESCRIPTIONLINE2 = item.description
            postercontent.appendChild(node)
        end for
        showpostergrid(postercontent)
    end sub
    ```
    Check the results:  
    <img src="screenshots/l4_contentscreen.png" width="400"/>

    Notice how almost all the application logic is now centralized in the home scene. You could think of the home scene as the "controller" in a Model View Controller architecture.  As the course progresses, most of the additional functionality will be added here.

That's it for Lesson 4.

Next Up:   
[Lesson 5: Back Button, Details Screen with Play Button, Video Screen](Lesson5.md)  
