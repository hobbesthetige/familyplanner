# Table of Contents #

* [NXMultiPhotoPicker](#markdown-header-NXMultiPhotoPicker)
* [NXPhotoAnnotator](#markdown-header-NXPhotoAnnotator)
* [ColorPickerCollectionViewController](#markdown-header-ColorPickerCollectionViewController)

# NXMultiPhotoPicker #

A basic alternative to `UIImagePickerController` which allows the user to select multiple photos.  

Customization is done through the `options` property of `NXMultiPhotoPicker`.  Images are returned in the `options.completion` closure.

![NXMultiPhotoPicker_250.png](https://bitbucket.org/repo/qeGGjy/images/1115361277-NXMultiPhotoPicker_250.png)

** Sample Usage **

```
#!swift
let picker = NXMultiPhotoPicker()
picker.options.targetPreviewCellLength = 150.0
picker.options.targetPhotoSize = CGSize(width: 500.0, height: 500.0)
picker.options.allowTakingPhotos = false
picker.options.completion = { [weak self] (images) in

    // Handle the selected images

    self?.dismissViewControllerAnimated(true, completion: nil)
}
presentViewController(picker, animated: true, completion: nil)

```


**Todo**

* Add support for peek and pop to view photos


# NXPhotoAnnotator #
Used to annotate photos.

![NXPhotoAnnotator_250.png](https://bitbucket.org/repo/qeGGjy/images/1623014420-NXPhotoAnnotator_250.png)

** Sample Usage - Storyboard **
```
#!swift
// Place empty view controller in the storyboard using the NXPhotoAnnotator class.

override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Check segue
if let annotator = segue.destinationViewController as? NXPhotoAnnotator where segue.identifier == "Annotate"
    annotator.image = UIImage(named: "IMG_0043")
    annotator.completionBlock = { [weak self] (image, cancelled) in

        // Check the cancelled flag and process the new image if necessary

        self?.dismissViewControllerAnimated(true, completion: nil)
    }
```


** Sample Usage - Programmatic **

```
#!swift

let annotator = NXPhotoAnnotator()
annotator.view.backgroundColor = UIColor.whiteColor()
annotator.image = UIImage(named: "IMG_0043")
annotator.completionBlock = { [weak self] (image, cancelled) in

    // Check the cancelled flag and process the new image if necessary

    self?.dismissViewControllerAnimated(true, completion: nil)
}
annotator.title = "Annotate Your Photo"
presentViewController(annotator, animated: true, completion: nil)

```



# ColorPickerCollectionViewController #

Used to select colors.  Can be used either as a UICollectionView (ColorPickerCollectionView) or UICollectionViewController (ColorPickerCollectionViewController)

The `ColorPickerCollectionView` class has two IBInspectable properties to control the number of colors displayed.

1. `hueVariations`
    * Corresponds to the number of rows (horizontal scrolling) or columns (vertical scrolling) for each hue.

2. `preferredColorTotal`
    * An approximate total number of colors to display.
    * *Needs to be fixed*


** Sample Usage - Programmatic **
```
#!swift

let colorPicker = ColorPickerCollectionViewController()
colorPicker.modalPresentationStyle = .Popover
colorPicker.popoverPresentationController?.barButtonItem = barButtonItem
colorPicker.selectionHandler = {(color) in
    // Do something
    // Dismiss
}
presentViewController(colorPicker, animated: true, completion: nil)
```

** Sample Usage - Storyboard **

Set the class of a `UICollectionViewController` to `ColorPickerCollectionViewController` in Interface Builder

-or-

Set the class of a `UICollectionView` to `ColorPickerCollectionView` in Interface Builder