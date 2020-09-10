import React from "react";
import { Col, Box } from "@tlon/indigo-react";
import { cite } from "~/logic/lib/util";
import { Note } from "~/types/publish-update";
import { Contact } from "~/types/contact-update";
import ReactMarkdown from "react-markdown";
import moment from "moment";
import { Link } from "react-router-dom";
import styled from "styled-components";
import { GraphNode } from "~/types/graph-update";

interface NotePreviewProps {
  host: string;
  book: string;
  node: GraphNode;
  contact?: Contact;
  hideNicknames?: boolean;
}

const WrappedBox = styled(Box)`
  overflow-wrap: break-word;
`;

export function NotePreview(props: NotePreviewProps) {
  const { node, contact } = props;
  const { post } = node;
  if (!post) {
    return null;
  }

  let name = post?.author;
  if (contact && !props.hideNicknames) {
    name = contact.nickname.length > 0 ? contact.nickname : post?.author;
  }
  if (name === post?.author) {
    name = cite(post?.author);
  }

  const numComments = node.children.size;
  const commentDesc =
    numComments === 0
      ? "No Comments"
      : numComments === 1
      ? "1 Comment"
      : `${numComments} Comments`;
  const date = moment(post["time-sent"]).fromNow();
  //const popout = props.popout ? "popout/" : "";
  const url = `/~publish/notebook/ship/${props.host}/${props.book}/note/${
    post.index.split("/")[1]
  }`;

  // stubbing pending notification-store
  const isRead = true;

  return (
    <Link to={url}>
      <Col mb={4}>
        <WrappedBox mb={1}>{post.contents[0]?.text}</WrappedBox>
        <WrappedBox mb={1}>
          <ReactMarkdown
            unwrapDisallowed
            allowedTypes={["text", "root", "break", "paragraph"]}
            source={post.contents[1]?.text}
          />
        </WrappedBox>
        <Box color="gray" display="flex">
          <Box
            mr={3}
            fontFamily={
              contact?.nickname && !props.hideNicknames ? "sans" : "mono"
            }
          >
            {name}
          </Box>
          <Box color={isRead ? "gray" : "green"} mr={3}>
            {date}
          </Box>
          <Box>{commentDesc}</Box>
        </Box>
      </Col>
    </Link>
  );
}
