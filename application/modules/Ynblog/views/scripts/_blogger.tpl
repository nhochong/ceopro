<?php echo '<?xml version="1.0" encoding="UTF-8"?><?xml-stylesheet href="http://www.blogger.com/styles/atom.css" type="text/css"?>' ?>
<feed xmlns='http://www.w3.org/2005/Atom' xmlns:gd='http://schemas.google.com/g/2005'
      xmlns:thr='http://purl.org/syndication/thread/1.0'>
    <id>tag:blogger.com,1999:blog-5956670440102797650.archive</id>
    <updated>2011-04-07T21:51:51.545-07:00</updated>
    <title type='text'>AP Group Website</title>
    <link rel='http://schemas.google.com/g/2005#feed' type='application/atom+xml'
          href='http://thitruong246.blogspot.com/feeds/archive'/>
    <link rel='self' type='application/atom+xml' href='http://www.blogger.com/feeds/5956670440102797650/archive'/>
    <link rel='http://schemas.google.com/g/2005#post' type='application/atom+xml'
          href='http://www.blogger.com/feeds/5956670440102797650/archive'/>
    <link rel='alternate' type='text/html' href='http://thitruong246.blogspot.com/'/>
    <author>
        <name>Huynh Linh</name>
        <uri>http://www.blogger.com/profile/16190713263258007528</uri>
        <email>noreply@blogger.com</email>
    </author>
    <generator version='7.00' uri='http://www.blogger.com'>Blogger</generator>
    <?php foreach ($this->blogs as $key => $blog) : ?>
        <entry>
            <id>tag:blogger.com,1999:blog-9196383144888789832.post-214661223658166209<?php echo $key ?></id>
            <published><?php echo $blog->creation_date ?></published>
            <updated><?php echo $blog->modified_date ?></updated>
            <category scheme='http://schemas.google.com/g/2005#kind'
                      term='http://schemas.google.com/blogger/2008/kind#post'/>
            <title type='text'><?php echo htmlspecialchars($blog->getTitle()) ?></title>
            <content type='html'><?php echo htmlspecialchars($blog->body) ?></content>
            <link rel='replies' type='text/html'
                  href='http://linhhv.blogspot.com/2011/04/hon-70-quai-x-dem-b-bt-gi_22.html#comment-form' title='0'/>
            <link rel='edit' type='application/atom+xml'
                  href='http://www.blogger.com/feeds/9196383144888789832/posts/default/2146612236581662094'/>
            <link rel='self' type='application/atom+xml'
                  href='http://www.blogger.com/feeds/9196383144888789832/posts/default/2146612236581662094'/>
            <author>
                <name><?php echo htmlspecialchars($blog->getOwner()->getTitle()) ?></name>
                <uri>http://www.blogger.com/profile/16190713263258007528</uri>
                <email>huynhlinhbk03@gmail.com</email>
            </author>
            <thr:total>0</thr:total>
            <gd:extendedProperty name='blogger.importType' value='IMPORTED'/>
        </entry>
    <?php endforeach; ?>
</feed>