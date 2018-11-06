# AstroAR Web Client

#### To use:

Check out this project, and from the root dir run:

1. `cd web-client`
2. `yarn install`
3. `yarn start`

**Editor**

1. Features the actual editor, a simple logo, and a publish button.
2. The editor is using [react-ace](https://asdas.com) -- a powerful open source editor with a lot of functionality
3. Clicking the publish button saves the script you have just written to the server, and then shows you a modal with the token for the script. You'll need to know this token so that you can select the correct script in the app.
4. Because this is just a demo you can see any Micro::App that anyone has written.
5. I haven't enabled 3D models in this demo version, however the functionality is very simple:

```
// import a model by clicking the 'import' button, then:

var model = Mosaico.import(<model_key>)
model.updatePosition( <position> )

// etc ...
```
